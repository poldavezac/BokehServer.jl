module Messages
using JSON
using HTTP.WebSockets
using ..AbstractTypes
using ..Protocol: Buffers, PROTOCOL_VERSION

const ID      = bokehidmaker()

abstract type iMessage end

struct RawMessage <: iMessage
    header   :: String
    contents :: String
    meta     :: String
    buffers  :: Vector{Pair{Vector{UInt8}, Vector{UInt8}}}
end

struct Message{T} <: iMessage
    header   :: Dict{String}
    contents :: Dict{String}
    meta     :: Dict{String}
    buffers  :: Buffers
end

"All possible messages"
const _HEADERS = Set{Symbol}([
    :ACK, :OK, :ERROR, :EMPTY,
    Symbol("PATCH-DOC"),
    Symbol("PUSH-DOC"),
    Symbol("PULL-DOC-REQ"),
    Symbol("PULL-DOC-REPLY"),
    Symbol("SERVER-INFO-REQ"),
    Symbol("SERVER-INFO-REPLY"),
])

const MESSAGES = Union{(Message{i} for i ∈ _HEADERS)...}

macro _h_str(val)
    symbols = Symbol.(strip.(split(val, ',')))
    @assert symbols ⊆ _HEADERS  "$symbols ⊈ $_HEADERS"
    return if length(symbols) ≡ 1
        Type{Message{symbols[1]}}
    else
        Union{(Type{Message{s}} for s ∈ symbols)...}
    end
end

macro msg_str(val)
    symbols = Symbol.(strip.(split(val, ',')))
    @assert symbols ⊆ _HEADERS
    return if length(symbols) ≡ 1
        Message{symbols[1]}
    else
        Union{(Message{s} for s ∈ symbols)...}
    end
end

name(::Type{Message{T}}) where {T} = T

struct ProtocolIterator
    hdr         :: Type{<:iMessage}
    hdrkeywords :: Dict{Symbol, Any}
    cnt         :: Union{String, NamedTuple}
    meta        :: Dict{Symbol, Any}
    buffers     :: Union{Buffers, Nothing}

    ProtocolIterator(hdr, content, meta; kwa...) = begin
        dmeta = Dict{Symbol, Any}(meta...)
        dhdr  = Dict{Symbol, Any}(kwa...)

        if :msgid ∈ keys(dmeta)
            dhdr[:msgid] = pop!(dmeta, :msgid)
        elseif isnothing(get(dhdr, :msgid, nothing))
            dhdr[:msgid] = string(ID())
        end

        buffers = if :buffers ∈ keys(dmeta)
            pop!(dmeta, :buffers)
        elseif :buffers ∈ keys(dhdr)
            pop!(dhdr, :buffers)
        else
            nothing
        end

        return new(hdr, dhdr, content, dmeta, buffers)
    end
end

messageid(itr::ProtocolIterator) = itr.hdrkeywords[:msgid]
messageid(msg::Message)          = msg.header["msgid"]
requestid(msg::Message)          = msg.header["reqid"]

ProtocolIterator(hdr, meta; kwa...) = ProtocolIterator(hdr, (;), meta; kwa...)

Base.eltype(::Type{ProtocolIterator}) = Union{String, Vector{UInt8}}
Base.length(itr::ProtocolIterator) = isnothing(itr.buffers) ? 3 : 3 + 2length(itr.buffers)

function Base.iterate(itr::ProtocolIterator, state = 1)
    if state ≡ 1
        outp = "{\"msgid\":\"$(messageid(itr))\",\"msgtype\":\"$(name(itr.hdr))\""
        (:reqid ∈ keys(itr.hdrkeywords)) && (outp*= ",\"reqid\":\"$(itr.hdrkeywords[:reqid])\"")
        isnothing(itr.buffers) || (outp*= ",\"num_buffers\":$(length(itr.buffers))")
        outp *= "}"
    elseif state ≡ 2
        outp  = JSON.json(itr.meta)
    elseif state ≡ 3
        outp  = itr.cnt isa String ? itr.cnt : JSON.json(itr.cnt)
    elseif state > length(itr)
        return nothing
    else
        ind  = state - 4
        outp = (iszero(ind%2) ? first : last)(itr.buffers[(ind ÷ 2) + 1])
    end
    return outp, state+1
end

message(hdr::_h"PUSH-DOC", doc::NamedTuple; meta...)          = ProtocolIterator(hdr, doc, meta)
message(hdr::_h"ACK,PULL-DOC-REQ,SERVER-INFO-REQ"; meta...)   = ProtocolIterator(hdr, (;), meta)
message(hdr::_h"OK",    reqid::String; meta...)               = ProtocolIterator(hdr, (;), meta; reqid)
message(hdr::_h"ERROR", reqid::String, text::String; meta...) = ProtocolIterator(
    hdr,
    (; 
        text,
        traceback = let io = IOBuffer()
           for (exc, bt) in current_exceptions()
               showerror(io, exc, bt)
               println(io)
           end
           String(take!(io))
       end
    ),
    meta;
    reqid
)

message(hdr::_h"PATCH-DOC", evts::NamedTuple, buffers::Buffers; meta...)  = ProtocolIterator(hdr, evts, meta; buffers)
message(hdr::_h"PULL-DOC-REPLY", reqid::String, doc::NamedTuple; meta...) = ProtocolIterator(hdr, doc, meta; reqid)
message(hdr::_h"SERVER-INFO-REPLY", reqid::String; meta...)               = ProtocolIterator(
    hdr,
    (; version_info = (; bokeh = "$(PROTOCOL_VERSION)", server = "$(PROTOCOL_VERSION)")),
    meta;
    reqid
)

function sendmessage(@nospecialize(ios::Union{AbstractVector, AbstractSet, Tuple}), 𝑇::Type{<:iMessage}, args...; kwa...) :: String
    @assert !isempty(ios)
    msgid = string(ID())
    for io ∈ ios
        sendmessage(io, 𝑇, args...; msgid, kwa...)
    end
    return get(kwa, :msgid, msgid)
end

function sendmessage(io::WebSockets.WebSocket, T::Type{<:iMessage}, args...; kwa...) :: Union{Missing, String}
    itr = message(T, args...; kwa...)
    for line ∈ collect(itr)
        WebSockets.isclosed(io) && (return missing)
        WebSockets.send(io, line)
    end
    return messageid(itr)
end

const _PATT = r"\"num_buffers\"\s*:\s*(\d*)"

nodata(ws) = (WebSockets.isclosed(ws) || iszero(Base.bytesavailable(ws.io))) && !isreadable(ws.io.io)

function _read(𝑇::Type, ws, (timeout, sleepperiod))
    timedout = timeout + time()
    while nodata(ws) && time() < timedout
         (sleepperiod ≤ 0.) || sleep(sleepperiod)
         yield()
    end
    
    return nodata(ws) ? (𝑇 ≡ Char ? "" : 𝑇[]) : WebSockets.receive(ws)
end

function RawMessage(ws, timeout :: Pair{<:Real, <:Real})
    header   = _read(Char, ws, timeout)
    contents = _read(Char, ws, timeout)
    meta     = _read(Char, ws, timeout)
    buffers  = let m = match(_PATT, header)
        T = eltype(fieldtype(RawMessage, :buffers))
        if isnothing(m)
            T[]
        else 
            T[
                let bhdr = _read(UInt8, ws, timeout)
                    data = _read(UInt8, ws, timeout)
                    bhdr => data
                end
                for _ ∈ 1:parse(Int64, m[1])
            ]
        end
    end
    return RawMessage(header, contents, meta, buffers)
end

function Message(raw::RawMessage)
    if isempty(raw.header)
        return Message{:EMPTY}(
            Dict{String, Any}(),
            Dict{String, Any}(),
            Dict{String, Any}(),
            Pair{Dict{String, Any}, Vector}[]
        )
    end
    hdr = JSON.parse(raw.header)
    return Message{Symbol(hdr["msgtype"])}(
        hdr,
        JSON.parse(raw.meta),
        JSON.parse(raw.contents),
        collect(eltype(Buffers), (JSON.parse(i)["id"] => j for (i, j) ∈ raw.buffers))
    )
end

function receivemessage(ws, timeout :: Real, sleepperiod::Real)
    return Message(RawMessage(ws, timeout => sleepperiod))
end

export sendmessage, Message, @msg_str, receivemessage
end

using .Messages
