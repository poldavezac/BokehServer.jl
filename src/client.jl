module Client
using HTTP.WebSockets
using ..Tokens
using ..Events
using ..Protocol
using ..Protocol.Messages: @msg_str, requestid, Message
using ..Server: CONFIG

macro safely(code)
    esc(:(if isopen(ws)
        $code
    else
        return
    end))
end

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
        token   :: AbstractString    = Tokens.token(Tokens.sessionid()),
        headers :: AbstractVector    = Pair[],
        timeout :: Int               = 60,
        kwa...
)
    @assert !any(first.(headers) .≡ Tokens.WEBSOCKET_PROTOCOL)
    push!(headers, Tokens.WEBSOCKET_PROTOCOL => "bokeh,$token")

    WebSockets.open(url; kwa..., headers) do ws :: WebSockets.WebSocket
        try
            @safely let msg = Protocol.receive(ws)
                @assert msg isa msg"ACK"
            end

            doc = Document()
            if dopull
                @safely msgid = Protocol.send(ws, msg"PULL-DOC-REQ")
                timedout = time() + timeout
                found    = false
                while time() < timedout
                    @safely if handle(Protocol.receive(ws), msgid, doc)
                        found = true
                        break
                    end
                end

                if !found
                    @error "Timed-out"
                    return nothing
                end
            end

            patchdoc(()->𝐹(ws, doc), doc, events, ws)
        catch exc
            @error "Client error" exception = (exc, Base.catch_backtrace())
        finally
            close(ws)
        end
        return doc
    end
end

end
using .Client
