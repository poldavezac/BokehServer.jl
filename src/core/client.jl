module Client
using HTTP.WebSockets
using ..Tokens
using ..Documents: Document
using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str, requestid, Message
using ..Server: CONFIG

struct ServerError <: Exception end

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

function handle(msg::msg"PULL-DOC-REPLY", msgid, doc)
    @debug "Receive a reply" msg.header
    if requestid(msg) ≡ msgid
        Protocol.onreceive!(msg, doc, Events.NullEventList())
        return true
    end
    return false
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
        doc = nothing
        try
            let msg = Protocol.receivemessage(ws, CONFIG.wstimeout, CONFIG.wssleepperiod)
                @assert msg isa msg"ACK"
            end

            doc = Document()
            if dopull
                msgid    = Protocol.sendmessage(ws, msg"PULL-DOC-REQ")
                timedout = time() + timeout
                found    = false
                while time() < timedout
                    if handle(Protocol.receivemessage(ws, CONFIG.wstimeout, CONFIG.wssleepperiod), msgid, doc)
                        found = true
                        break
                    end
                end

                if !found
                    @error "Timed-out"
                    return nothing
                end
            end

            Protocol.patchdoc(()->𝐹(ws, doc), doc, events, ws)
        catch exc
            exc isa ServerError || (@error "Client error" exception = (exc, Base.catch_backtrace()))
        finally
            close(ws)
            yield()
        end
        return doc
    end
end

end
using .Client
