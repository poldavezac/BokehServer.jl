module WSRoute
using HTTP
using HTTP.WebSockets
using HTTP.WebSockets: WebSocket, WebSocketError
using ...Protocol
using ...Protocol.Messages: @msg_str
using ...Server
using ...Server: iApplication, SessionContext

function route(req::HTTP.Stream, app::Server.iApplication)
    WebSockets.upgrade(req) do ws::WebSocket
        session = get(app, req)
        onopen(req, ws, app, session)
        while isopen(ws)
            onmessage(ws, app, session)
        end
        onclose(ws, session)
    end
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
        if !isopen(ws)
            return onclose(ws, session)
        end
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

function onopen(req::HTTP.Stream, ws::WebSocket, app::iApplication, session::SessionContext)
    (subprotocol, token) = let args = Server.getparams(req)
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

    push!(session.clients, ws)
    @safely Protocol.send(ws, msg"ACK")
end

function onmessage(ws::WebSocket, app::iApplication, session::SessionContext)
    msg = @safely Protocol.receive(ws)
    @async try
        answer = Server.handle(msg, session.doc, Server.eventlist(app, session))
        @safely Protocol.send(ws, anwser...)
    catch exc
        txt = sprint(showerror, exc)
        @safely Protocol.send(ws, msg"ERROR", msg.header["reqid"], txt)
    end
end

function onclose(ws::WebSocket, session::SessionContext)
    pop!(session.clients, ws, nothing)
    nothing
end

function handle(msg::msg"SERVER-INFO-REQ", ::iApplication, ::SessionContext)
    return (msg"SERVER-INFO-REPLY", msg.header["msgid"])
end

function handle(msg::msg"PULL-DOC-REQ", ::iApplication, session::SessionContext)
    return (msg"SERVER-INFO-REPLY", msg.header["msgid"], pushdoc(session.doc))
end

struct MessageOrBufferIO{T}
    io::T
end

for (tpe, func) ∈ (msg"PULL-DOC-REPLY" => :pushdoc!, msg"PATCH-DOC" => :patchdoc!)
    @eval function $func(μ::$tpe, app::iApplication, session::SessionContext)
        oldids = allids(doc)
        events = eventlist(app, session)
        Events.eventlist(events) do _
            $func(doc, μ.contents)

            Events.flushevents!(events)
        end

        outp  = patchdoc(events, doc, oldids)
        buff  = Pair{Vector{UInt8}, String}[]
        for io ∈ session.clients
            send(MessageOrBufferIO{typeof(io)}(io), msg"PATCH-DOC", outp, buff)
        end
        return (msg"OK",)
    end
end

Base.write(io::MessageOrBufferIO, v) = write(io.io, v)

for (i, j) ∈ ((Vector{UInt8} => WebSockets.WS_BINARY), String => WebSockets.WS_TEXT)
    @eval function Base.write(io::MessageOrBufferIO{WebSocket}, msg::$i)
        io.io.frame_type = $j
        write(io.io, msg)
    end
end

wsclose(ws::WebSockets.WebSocket, ::iApplication, ::SessionContext) = close(ws)

function wserror(::iApplication, ::SessionContext, exc::Exception)
    @info "Websocket error" exception = exc
end
end
using .WSRoute

@route GET ws WSRoute
