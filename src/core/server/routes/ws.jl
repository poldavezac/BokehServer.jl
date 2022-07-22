module WSRoute
using HTTP
using HTTP.WebSockets
using ...Events
using ...Protocol
using ...Protocol.Messages: @msg_str, messageid, nodata
using ...Server
using ...Server: iApplication, SessionContext
using ...Tokens
const SUBPROTOCOL = "bokeh"

function route(io::HTTP.Stream, 𝐴::Server.iApplication)
    let hdr = Tokens.subprotocol(HTTP.headers(io.message), SUBPROTOCOL)
        isnothing(hdr) && Server.httperror("Upgrade protocol is missing")
        HTTP.setheader(io, Tokens.WEBSOCKET_PROTOCOL => SUBPROTOCOL)
    end

    out = WebSockets.upgrade(io) do ws::WebSockets.WebSocket
        waittime = Server.CONFIG.wssleepperiod
        session  = nothing
        try
            session = onopen(ws, 𝐴) :: SessionContext
            if !isnothing(session)
                while !WebSockets.isclosed(ws)
                    if nodata(ws)
                        (waittime ≤ 0) || sleep(waittime)
                    else
                        onmessage(ws, 𝐴, session)
                    end
                    yield()
                end
            end
            nothing
        catch exc
            if (exc isa InterruptException)
                exc
            else
                wserror(exc, 𝐴, session,)
                nothing
            end
        finally
            onclose(ws, 𝐴, session)
            close(ws)
        end
    end
    # rethrow here to escape a try-catch within the `WebSockets` module
    (out isa InterruptException) && throw(out)
end

macro wsassert(test, msg::String)
    esc(quote
        if !($test)
            wsclose(ω, 𝐴)
            Server.httperror($msg, 1000)
        end
    end)
end

macro safely(code)
    esc(:(if !WebSockets.isclosed(ω)
        $code
    else
        onclose(ω, 𝐴, σ)
        return nothing
    end))
end

function onopen(ω::WebSockets.WebSocket, 𝐴::iApplication) :: SessionContext
    req   = ω.request
    token = Tokens.token(HTTP.headers(req), SUBPROTOCOL)
    @wsassert !isnothing(token) "No token received in subprotocol header"

    payload = Server.Tokens.payload(token)
    @wsassert ("session_expiry" ∈ keys(payload)) "Session expiry has not been provided"
    @wsassert (time() < (payload["session_expiry"])::Float64) "Token is expired"
    @wsassert Server.checktokensignature(𝐴, token) "Invalid token signature"

    σ = get!(𝐴, Server.SessionKey(Tokens.sessionid(token), token)) :: SessionContext
    push!(σ.clients, ω)
    @safely Protocol.sendmessage(ω, msg"ACK")
    σ
end

function onmessage(ω::WebSockets.WebSocket, 𝐴::iApplication, σ::SessionContext)
    @safely msg = Protocol.receivemessage(ω, Server.CONFIG.wstimeout, Server.CONFIG.wssleepperiod)
    yield()
    try
        answer = handle(msg, 𝐴, σ)
        @safely Protocol.sendmessage(ω, answer...)
    catch exc
        @safely Protocol.sendmessage(ω, msg"ERROR", messageid(msg), sprint(showerror, exc))
        rethrow(exc)
    end
end

onclose(ω::WebSockets.WebSocket, ::iApplication, ::Nothing) = nothing
function onclose(ω::WebSockets.WebSocket, ::iApplication, σ::SessionContext)
    pop!(σ.clients, ω, nothing)
    nothing
end

struct EmptyMessageError <: Exception end
handle(msg::msg"EMPTY", _...) = throw(EmptyMessageError())

function handle(msg::msg"SERVER-INFO-REQ", ::iApplication, ::SessionContext)
    return (msg"SERVER-INFO-REPLY", messageid(msg))
end

function handle(msg::msg"PULL-DOC-REQ", ::iApplication, σ::SessionContext)
    return (msg"PULL-DOC-REPLY", messageid(msg), Protocol.pushdoc(σ.doc))
end

function handle(μ::msg"PUSH-DOC,PATCH-DOC", 𝐴::iApplication, σ::SessionContext)
    Protocol.onreceive!(μ, σ.doc, Server.eventlist(𝐴), σ.clients...)
    return (msg"OK", messageid(μ))
end

wsclose(ω::WebSockets.WebSocket, ::iApplication) = close(ω)

function wserror(exc::Exception, _...)
    @error "Server ws error" exception = (exc, Base.catch_backtrace())
    rethrow(exc)
end

function wserror(exc::WebSockets.WebSocketError, _...)
    WebSockets.isok(exc) || (@error "Websocket error" exception = (exc, Base.catch_backtrace()))
end

wserror(exc::Base.IOError, _...) = @error "IO error" exception = (exc, Base.catch_backtrace())
wserror(::EmptyMessageError, _...) = nothing

precompile(route, (HTTP.Stream{HTTP.Request}, Server.Application))
precompile(onopen, (WebSockets.WebSocket, Server.Application))
precompile(onmessage, (WebSockets.WebSocket, Server.Application, Server.SessionContext))
end
using .WSRoute

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::iApplication, ::Val{:ws}) = WSRoute.route(http, 𝐴)
