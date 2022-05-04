module Protocol
using ..AbstractTypes
using JSON

const ID = BokehIdMaker()
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

function _send(chan::AbstractChannel, hdr::Symbol, meta::Base.Pairs; kwa...)
    return _send(chan, hrd, "{}", meta; kwa...)
end

function _send(chan::AbstractChannel, hdr::Symbol, content::NamedTuple, meta::Base.Pairs; kwa...)
    return _send(chan, hrd, JSON.json(content), meta; kwa...)
end

function _send(
        chan::AbstractChannel,
        hdr::Symbol,
        cnt::String,
        meta::Base.Pairs;
        buffers::Union{Buffers, Nothing} = nothing, 
        kwa...
)
    put!(
        chan,
        header(
            hdr;
            num_buffers = isnothing(buffers) ? 0 : length(buffers),
            kwa...
        )
    )
    put!(chan, JSON.json(meta))
    put!(chan, cnt)
    for i ∈ buffers, j ∈ i
        put!(j)
    end
end

sendack(chan::AbstractChannel; meta...) = _send(:ACK, "{}", meta)
sendok(chan::AbstractChannel; reqid::Int, meta...) = _send(:OK, "{}", meta; requid)

function senderror(chan::AbstractChannel, reqid::Int, text::String; meta...)
    return _send(
        chan,
        val,
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
end

function sendpatchdoc(chan::AbstractChannel, evts::String, buffers::Buffers; meta...)
    return _send(Symbol("PATCH-DOC"), evts, meta; buffers)
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
