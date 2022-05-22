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
    request :: HTTP.Request
end

struct SessionContext <: iSessionContext
    id      :: String
    token   :: String
    request :: HTTP.Request
    doc     :: iDocument
    clients :: Set{IO}

    SessionContext(b::SessionKey) = new(
        b.id, b.token, b.request, Document(), Set{IO}()
    )
    SessionContext(a...) = new(a..., Document(), Set{IO}())
end

Base.push!(σ::SessionContext, ws::IO) = push!(σ.clients, ws)
Base.pop!(σ::SessionContext, ws::IO) = pop!(σ.clients, ws, nothing)
Base.in(ws::IO, σ::SessionContext) = ws ∈ σ.clients

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
        id = Tokens.sessionid(token)
    elseif isnothing(id)
        id = Tokens.sessionid()
    end

    if isnothing(token)
        cookies = Dict(HTTP.cookies(request)...)
        headers = Dict(HTTP.headers(request)...)
        if !isempty(cookies) &&  "Cookie" ∈ keys(headers)
            pop!(headers, "Cookie")
        end

        token = Tokens.token(id; headers, cookies)
    end
    return SessionKey(id, token, request)
end
