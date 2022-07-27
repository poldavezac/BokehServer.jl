module Client
using HTTP.WebSockets
using ..Tokens
using ..Documents: Document
using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str, requestid, Message
using ..Server: CONFIG

struct ServerError <: Exception end

struct MessageHandler
    ws      :: WebSockets.WebSocket
    events  :: Events.iEventList
    doc     :: Document
    timeout :: Int
end

handle(msg, _...) = begin
    @info "Receive a message" msg.header
    msg
end
handle(msg::msg"ACK,EMPTY", _...) = msg

function handle(msg::msg"ERROR", _...)
    @error(
        "Received an error message",
        message = msg.contents["text"],
        traceback = msg.contents["traceback"]
    )
    throw(ServerError())
end

function handle(msg::msg"PULL-DOC-REPLY", msgid, ω::MessageHandler)
    @debug "Receive a reply" msg.header
    Protocol.isreply(msg"PULL-DOC-REQ", msgid, msg) && Protocol.onreceive!(msg, ω.doc, ω.events)
end

function handle(μ::msg"PUSH-DOC,PATCH-DOC", ω::MessageHandler)
    Protocol.onreceive!(μ, ω.doc, ω.events, ω.ws)
end

function receivemessage(ω::MessageHandler, args...)
    msg = Protocol.receivemessage(ω.ws, CONFIG.wstimeout, CONFIG.wssleepperiod)
    handle(msg, args..., ω)
    msg
end

sendmessage(ω::MessageHandler, msg) = Protocol.sendmessage(ω.ws, msg)

function sendmessage(ω::MessageHandler, inpt::Type{msg"PULL-DOC-REQ"})
    msgid    = Protocol.sendmessage(ω.ws, inpt)
    timedout = time() + ω.timeout
    while time() < timedout
        msg = receivemessage(ω, msgid)
        Protocol.isreply(inpt, msgid, msg) && return msg
    end
    return msg"EMPTY"()
end

function open(
        𝐹::Function,
        url,
        dopull  :: Bool              = true,
        events  :: Events.iEventList = Events.NullEventList();
        token   :: AbstractString    = Tokens.token(Tokens.sessionid()),
        headers :: AbstractVector    = Pair[],
        timeout :: Int               = 60,
        retry   :: Bool              = false,
        kwa...
)
    @assert !any(first.(headers) .≡ Tokens.WEBSOCKET_PROTOCOL)
    push!(headers, Tokens.WEBSOCKET_PROTOCOL => "bokeh,$token")

    WebSockets.open(url; kwa..., retry, headers) do ws :: WebSockets.WebSocket
        return try
            hdl = MessageHandler(ws, events, Document(), timeout)
            let msg = receivemessage(hdl)
                @assert msg isa msg"ACK"
            end

            if dopull && isempty(sendmessage(hdl, msg"PULL-DOC-REQ"))
                @error "Timed-out"
                return nothing
            end

            Protocol.patchdoc(hdl.doc, hdl.events, hdl.ws) do
                applicable(𝐹, hdl.ws, hdl.doc) ? 𝐹(hdl.ws, hdl.doc) : 𝐹(hdl)
            end

            hdl.doc
        catch exc
            exc isa ServerError || (@error "Client error" exception = (exc, Base.catch_backtrace()))
            exc
        finally
            close(ws)
            yield()
        end
    end
end

end
using .Client
