module Messages
using JSON
using ..AbstractTypes
using ..Protocol: Buffers

const ID = bokehidmaker()

struct ProtocolIterator
    hdr         :: Symbol
    hdrkeywords :: Dict{Symbol, Any}
    cnt         :: Union{String, NamedTuple}
    meta        :: Dict{Symbol, Any}
    buffers     :: Union{Buffers, Nothing}

    ProtocolIterator(hdr::Symbol, content, meta; kwa...) = begin
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

ProtocolIterator(hdr::Symbol, meta; kwa...) = ProtocolIterator(hdr, (;), meta; kwa...)

Base.eltype(::Type{ProtocolIterator}) = String
Base.length(itr::ProtocolIterator) = isnothing(itr.buffers) ? 3 : 3 + 2length(itr.buffers)

function Base.iterate(itr::ProtocolIterator, state = 1)
    if state ≡ 1
        outp = "{\"msgid\":\"$(itr.hdrkeywords[:msgid])\",\"msgtype\":\"$(itr.hdr)\""
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

message(::Val{:ACK}; meta...)                             = ProtocolIterator(:ACK, meta)
message(::Val{:OK}, reqid::String; meta...)               = ProtocolIterator(:OK, meta; reqid)
message(::Val{:ERROR}, reqid::String, text::String; meta...) = ProtocolIterator(
    :ERROR,
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

function message(::Val{:PATCHDOC}, evts::String, buffers::Buffers; meta...)
    return ProtocolIterator(Symbol("PATCH-DOC"), evts, meta; buffers)
end

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
