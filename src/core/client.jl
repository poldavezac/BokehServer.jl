module Client
using HTTP.WebSockets
using ..Tokens
using ..Documents: Document
using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str, requestid, Message
using ..Server: CONFIG

struct ServerError <: Exception end

@Base.kwdef struct MessageHandler
    ws            :: WebSockets.WebSocket
    events        :: Events.iEventList
    doc           :: Document
end

handle(msg, _...) = begin
    @info "Receive a message" msg.header
    false
end

function handle(msg::msg"ERROR", _)
    @error(
        "Received an error message",
        message = msg.content["text"],
        traceback = msg.content["traceback"]
    )
    throw(ServerError())
end

function handle(msg::msg"PULL-DOC-REPLY", msgid, ω::MessageHandler)
    @debug "Receive a reply" msg.header
    if requestid(msg) ≡ msgid
        Protocol.onreceive!(msg, ω.doc, ω.events)
        return true
    end
    return false
end

handle(μ::msg"PUSH-DOC,PATCH-DOC", ω::MessageHandler) = Protocol.onreceive!(μ, ω.doc, ω.events, ω.ws)

function receivemessage(ω::MessageHandler, args...)
    handle(Protocol.receivemessage(ω.ws, CONFIG.wstimeout, CONFIG.wssleepperiod), args..., ω)
end

sendmessage(ω::MessageHandler) = Protocol.receivemessage(ω.ws, CONFIG.wstimeout, CONFIG.wssleepperiod)

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
            hdl = MessageHandler(; ws, events, doc = Document())
            let msg = Protocol.receivemessage(ws, CONFIG.wstimeout, CONFIG.wssleepperiod)
                @assert msg isa msg"ACK"
            end

            if dopull
                msgid    = Protocol.sendmessage(ws, msg"PULL-DOC-REQ")
                timedout = time() + timeout
                found    = false
                while time() < timedout
                    if receivemessage(hdl, msgid)
                        found = true
                        break
                    end
                end

                if !found
                    @error "Timed-out"
                    return nothing
                end
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
