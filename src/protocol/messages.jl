module Messages
using JSON
using HTTP.WebSockets: WebSocket, WS_BINARY, WS_TEXT
using ..AbstractTypes
using ..Protocol: Buffers

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
    buffers  :: Vector{Pair{Dict{String}, Vector}}
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
    elseif isnothing(itr.buffers) || state > 3 + 2length(itr.buffers)
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
    (; version_info = (; bokeh = Bokeh.PYTHON_VERSION, server = Bokeh.PYTHON_VERSION)),
    meta;
    reqid
)

function send(@nospecialize(ios::Union{AbstractVector, AbstractSet, Tuple}), 𝑇::msg"PATCH-DOC", args...; kwa...) :: String
    @assert !isempty(io)
    msgid = string(ID())
    for io ∈ ios
        send(io, 𝑇, args...; msgid, kwa...)
    end
    return get(kwa, :msgid, msgid)
end

frametype!(io::WebSocket, ::Vector{UInt8}) = (io.frame_type = WS_BINARY)
frametype!(io::WebSocket, ::String)        = (io.frame_type = WS_TEXT)
frametype!(_...) = nothing

function send(io::IO, T::Type{<:iMessage}, args...; kwa...) :: Union{Missing, String}
    itr = message(T, args...; kwa...)
    for line ∈ collect(itr)
        if isopen(io)
            frametype!(io, line)
            write(io, line)
        else
            return missing
        end
    end
    return messageid(itr)
end

const _PATT = r"\"num_buffers\"\s*:\s*(\d*)"

function _read(ws, (timeout, sleepperiod))
    timedout = timeout + time()
    while isopen(ws) && iszero(Base.bytesavailable(ws.io)) && time() < timedout
         (sleepperiod ≤ 0.) || sleep(sleepperiod)
         yield()
    end
    
    readavailable(ws)
end

_read(::Type{Char},  ws, t) = isopen(ws) ? String(_read(ws, t))  : ""
_read(::Type{UInt8}, ws, t) = isopen(ws) ? collect(_read(ws, t)) : UInt8[]
        
function RawMessage(ws, timeout :: Pair{<:Real, <:Real})
    # @assert !iszero(Base.bytesavailable(ws.io))
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
    parse((i,j)::Pair) = parse(i) => j
    hdr = JSON.parse(raw.header)
    return Message{Symbol(hdr["msgtype"])}(
        hdr,
        JSON.parse(raw.meta),
        JSON.parse(raw.contents),
        parse.(raw.buffers)
    )
end

function receive(ws, timeout :: Real, sleepperiod::Real)
    return Message(RawMessage(ws, timeout => sleepperiod))
end

export send, receive, Message, @msg_str
end

using .Messages
