module Client
using HTTP.WebSockets
using ..Tokens
using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str, requestid, Message

const WEBSOCKET_PROTOCOL = "Sec-WebSocket-Protocol"
handle(_...) = false

function handle(msg::msg"PULL-DOC-REPLY", msgid, doc)
    if requestid(msg) ≡ msgid
        onreceive!(msg, doc, Events.NullEventList())
        return true
    end
    return false
end

function open(
        𝐹::Function,
        url,
        dopull  :: Bool              = true,
        events  :: Events.iEventList = Events.NullEventList();
        token   :: String            = Tokens.token(Tokens.sessionid()),
        headers :: AbstractVector    = Pair[],
        timeout :: Int               = 60,
        kwa...
)
    @assert !any(first.(headers) .≡ WEBSOCKET_PROTOCOL)
    push!(headers, WEBSOCKET_PROTOCOL => "bokeh,$token")

    WebSockets.open(url; kwa..., headers) do ws :: WebSockets.WebSocket
        let msg = Protocol.receive(ws)
            @assert msg isa msg"ACK"
        end

        doc = Document()
        if dopull
            msgid    = Protocol.send(ws, msg"PULL-DOC-REQ")
            timedout = time() + timeout
            while time() < timedout
                handle(Protocol.receive(ws), msgid, doc) && break
            end
        end

        patchdoc(()->𝐹(ws, doc), doc, events, ws)
        return doc
    end
end

end
