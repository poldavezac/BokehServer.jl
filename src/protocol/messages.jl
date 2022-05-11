module Messages
using JSON
using ..AbstractTypes
using ..Protocol: Buffers

const ID = bokehidmaker()

macro msg_str(val)
    if occursin(",", val)
        Union{(Val{Symbol(strip(i))} for i ∈ split(val, ','))...}
    else
        Val{Symbol(strip(val))}
    end
end

struct ProtocolIterator
    hdr         :: Val
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
            dhdr[:msgid] = ID()
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

ProtocolIterator(hdr, meta; kwa...) = ProtocolIterator(hdr, (;), meta; kwa...)

Base.eltype(::Type{ProtocolIterator}) = String
Base.length(itr::ProtocolIterator) = isnothing(itr.buffers) ? 3 : 3 + 2length(itr.buffers)

function Base.iterate(itr::ProtocolIterator, state = 1)
    if state ≡ 1
        outp = "{\"msgid\":\"$(itr.hdrkeywords[:msgid])\",\"msgtype\":\"$(typeof(itr.hdr).parameters[1])\""
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

message(hdr::msg"PUSH-DOC", doc::NamedTuple; meta...)          = ProtocolIterator(hdr, doc, meta)
message(hdr::msg"ACK,PULL-DOC-REQ,SERVER-INFO-REQ"; meta...)   = ProtocolIterator(hdr, (;), meta)
message(hdr::msg"OK",    reqid::String; meta...)               = ProtocolIterator(hdr, (;), meta; reqid)
message(hdr::msg"ERROR", reqid::String, text::String; meta...) = ProtocolIterator(
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

message(hdr::msg"PATCH-DOC", evts::NamedTuple, buffers::Buffers; meta...)  = ProtocolIterator(hdr, evts, meta; buffers)
message(hdr::msg"PULL-DOC-REPLY", reqid::String, doc::NamedTuple; meta...) = ProtocolIterator(hdr, doc, meta; reqid)
message(hdr::msg"SERVER-INFO-REPLY", reqid::String; meta...)               = ProtocolIterator(
    hdr,
    (; version_info = (; bokeh = Bokeh.PYTHON_VERSION, server = Bokeh.PYTHON_VERSION)),
    meta;
    reqid
)

send(ws, tpe::Symbol, args...; kwa...) = send(ws, Val(tpe), args...; kwa...)
function send(ws, tpe::Val, args...; kwa...)
    for line ∈ message(tpe, args...; kwa...)
        write(ws, line)
    end
end

function receive(ws)
    hdr     = JSON.parse(readavailable(ws))
    cnt     = JSON.parse(readavailable(ws))
    meta    = JSON.parse(readavailable(ws))

    nbuff   = get(hdr, "num_buffers", nothing)
    isnothing(nbuff) && return (; header = hdr, metadata = meta, content = cnt)

    buffers = Pair{Any, Any}[
        let bhdr = JSON.parse(readavailable(ws))
            data = JSON.parse(readavailable(ws))
            bhdr => data
        end
        for _ ∈ 1:nbuff
    ]
    return (; header = hdr, metadata = meta, content = cnt, buffers = buffers)
end

export message, send, receive
end
using .Messages
