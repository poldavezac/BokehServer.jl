module Protocol
using ..AbstractTypes
using JSON

const ID      = bokehidmaker()
const Buffers = Vector{Pair{String, String}}

function header(
        val   :: Symbol,
        msgid :: Int = ID();
        reqid :: Union{Int, Nothing} = nothing,
        num_buffers :: Union{Int, Nothing} = nothing,
        kwa...
)
    msg = "{\"msgid\":\"$msgid\",\"msgtype\":\"$(typeof(val).parameters[1])\""
    isnothing(reqid)       || (msg*= ",\"reqid\":\"$reqid\"")
    isnothing(num_buffers) || (msg*= ",\"num_buffers\":$num_buffers")
    return msg * "}"
end

struct ProtocolIterator
    hdr         :: String
    hdrkeywords :: Base.Pairs
    cnt         :: Union{String, NamedTuple}
    meta        :: Base.Pairs
    buffers     :: Union{Buffers, Nothing}
end

Base.eltype(::Type{ProtocolIterator}) = String
Base.length(itr::ProtocolIterator) = isnothing(itr.buffers) ? 3 : 3 + 2length(itr.buffers)

function Base.iterate(itr::ProtocolIterator, state = 1)
    if state ≡ 1
        outp = header(
            itr.hdr;
            num_buffers = isnothing(itr.buffers) ? 0 : length(itr.buffers),
            itr.kwa...
        )
    elseif state ≡ 2
        outp  = JSON.json(itr.meta)
    elseif state ≡ 3
        outp  = itr.cnt isa String ? itr.cnt : JSON.json(itr.cnt)
    elseif isnothing(itr.buffers) || state > 3 + 2length(itr.buffers)
        return nothing
    else
        ind  = state - 3
        outp = itr.buffers[ind ÷ 2][ind % 2]
    end
    return outp, state+1
end

function ProtocolIterator(hdr::Symbol, meta::Base.Pairs; kwa...)
    return ProtocolIterator(hrd, kwa, "{}", meta, nothing)
end

function ProtocolIterator(hdr::Symbol, content::NamedTuple, meta::Base.Pairs; kwa...)
    return ProtocolIterator(hrd, kwa, content, meta, nothing)
end

message(::Val{:ACK}, meta...)            = ProtocolIterator(:ACK, "{}", meta)
message(::Val{:OK}, reqid::Int, meta...) = ProtocolIterator(:OK, "{}", meta; requid)
message(::Val{:ERROR}, reqid::Int, text::String; meta...) = ProtocolIterator(
    :ERROR,
    (; 
        text,
        traceback = let io = IOBuffer()
           for (exc, bt) in current_exceptions()
               showerror(io, exc, bt)
               println(io)
           end
           string(take!(io))
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


function receive(chan::AbstractChannel)
    hdr     = JSON.parse(take!(chan))
    cnt     = JSON.parse(take!(chan))
    meta    = JSON.parse(take!(chan))

    nbuff   = get(hdr, "num_buffers", nothing)
    isnothing(nbuff) && return (; header = hdr, metadata = meta, content = cnt)

    buffers = Pair{Any, Any}[
        let bhdr = JSON.parse(take!(chan))
            data = JSON.parse(take!(chan))
            bhdr => data
        end
        for _ ∈ 1:nbuff
    ]
    return (; header = hdr, metadata = meta, content = cnt, buffers = buffers)
end
end
