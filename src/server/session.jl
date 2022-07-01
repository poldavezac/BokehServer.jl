abstract type iSessionContext end

"""
A temporary `SessionContext`, without doc or clients.
It allows querying an `iApplication` for an existing `SessionContext`
without creating undue `iDocument`. An `iApplication` must not
store anything but a complete SessionContext
"""
struct SessionKey <: iSessionContext
    id      :: String
    token   :: String

    function SessionKey(id, token; extra...)
        if isnothing(token)
            isnothing(id) && (id = Tokens.sessionid())
            token = Tokens.token(id; extra...)
        else
            id = Tokens.sessionid(token)
        end

        return new(id, token)
    end
end

struct SessionContext <: iSessionContext
    id      :: String
    token   :: String
    doc     :: iDocument
    clients :: Set{WebSocket}

    SessionContext(b::SessionKey) = new(
        b.id, b.token, Document(), Set{WebSocket}()
    )
    SessionContext(a...) = new(a..., Document(), Set{WebSocket}())
end

Base.push!(σ::SessionContext, ws::WebSocket) = push!(σ.clients, ws)
Base.pop!(σ::SessionContext, ws::WebSocket) = pop!(σ.clients, ws, nothing)
Base.in(ws::WebSocket, σ::SessionContext) = ws ∈ σ.clients

function Base.close(σ::SessionContext)
    foreach(close, σ.clients)
    empty(σ.clients)
end

"""
    SessionKey(request::HTTP.Request)

Create a new SessionContext from the request. This
leaves the `doc` field empty. We will call on `initialize(::iApplication, ::iDocument)`
*if* we need to do so.
"""
function SessionKey(request::HTTP.Request)
    arguments = getparams(request)
    id        = get(arguments, "bokeh-session-id", nothing)
    if HTTP.hasheader(request, "Bokeh-Session-Id")
        isnothing(id) || httperror("session ID was provided as an argument and header")
        id = HTTP.getheader(request, "Bokeh-Session-Id")
    end

    token = get(arguments, "bokeh-token", nothing)
    if !isnothing(token)
        isnothing(id) || httperror("Both token and session ID were provided")
    end

    return if isnothing(token)
        cookies = Dict(HTTP.cookies(request)...)
        headers = Dict(HTTP.headers(request)...)
        if !isempty(cookies) &&  "Cookie" ∈ keys(headers)
            pop!(headers, "Cookie")
        end
        SessionKey(id, token; headers, cookies)
    else
        SessionKey(id, token)
    end
end
