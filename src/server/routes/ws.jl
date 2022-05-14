module WSRoute
using HTTP
using HTTP.WebSockets
using HTTP.WebSockets: WebSocket, WebSocketError
using ..Protocol
using ..Protocol.Messages: @msg_str
using ..Server
using ..Server: iApplication, SessionContext

wsclose(ws::WebSockets.WebSocket, ::iApplication, ::SessionContext) = close(ws)

function wserror(::iApplication, ::SessionContext, exc::Exception)
    @info "Websocket error" exception = exc
end

macro wsassert(test, msg::String)
    esc(quote
        if $test
            wsclose(ws, app, session)
            Server.htterror(1000, $msg)
        end
    end)
end

macro safely(code)
    esc(quote
        try
            $code
        catch exc
            if exc isa WebSocketError || exc isa Base.IOError
                wserror(exc)
                return nothing
            else
                rethrow()
            end
        end
    end)
end

function open(ws::WebSocket, app::iApplication, session::SessionContext)
    (subprotocol, token) = let args = Server.getparams(session)
        header = get(args, "Sec-WebSocket-Protocol", nothing)
        outp   = (; subprotocol = nothing, token = nothing)
        if !isnothing(header)
            opts = split(header, ',')
            if length(opts) ≡ 2
                outp = (; subprotocol = strip(opts[1]), token = strip(opts[2]))
            end
        end
        outp
    end

    @wsassert subprotocol ≡ "bokeh" "Subprotocol header is not 'bokeh'"
    @wsassert !isnothing(token) "No token received in subprotocol header"

    payload = Server.Tokens.payload(token)
    @wsassert ("session_expiry" ∈ keys(payload)) "Session expiry has not been provided"
    @wsassert (time() < payload["session_expiry"]) "Token is expired"
    @wsassert checktokensignature(app, token) "Invalid token signature"

    @safely send(ws, msg"ACK")
end

function onmessage(ws::WebSocket, app::iApplication, session::SessionContext)
    msg = @safely(Protocol.receive(ws))
    @async begin
        answers = try
            Server.handle(msg, session.doc, Server.eventlist(app, session))
        catch exc
            ((msg"ERROR", msg.header["msgid"], sprint(showerror, exc)),)
        end

        for answer ∈ answers
            @safely Protocol.send(ws, anwser...)
        end
    end
end
end
