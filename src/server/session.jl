using ..Documents

struct SessionContext
    id      :: String
    token   :: String
    request :: HTTP.Request
    doc     :: iDocument
    io      :: Ref{Union{IO, Nothing}}

    # force the non-initialization of the `doc` field
    SessionContext(args...) = new(args..., Document(), Ref{Union{IO, Nothing}}())
end

function Base.propertynames(::SessionContext, private :: Bool = false)
    return if private
        (:socket, fieldnames(SessionContext)...)
    else
        (:socket, :id, :token, :request, :doc)
    end
end

function Base.getproperty(σ::SessionContext, attr:Symbol)
    return attr ≡ :socket ? getfield(σ, :socket)[] : getfield(σ, attr)
end

function Base.setproperty!(σ::SessionContext, attr:Symbol, val)
    return attr ≡ :socket ? (getfield(σ, :socket)[] = val) : setfield!(σ, attr, val)
end

"""
    SessionContext(request::HTTP.Request)

Create a new SessionContext from the request. This
leaves the `doc` field empty. We will call on `initialize(::iApplication, ::iDocument)`
*if* we need to do so.
"""
function SessionContext(request::HTTP.Request)
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

        tokens  = Tokens.token(id; headers, cookies)
    end

    Tokens.check(token) || httperror("Invalid token or session ID")
    return SessionContext(id, token, request)
end

getparams(s::SessionContext) = getparams(s.request)
