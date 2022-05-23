using UUIDs

abstract type iApplication end
abstract type iGenericApplication <: iApplication end

struct SessionList
    sessions :: Dict{String, iSessionContext}
    SessionList() = new(fieldtype(SessionList, :sessions)())
end

Base.get(λ::SessionList, σ::iSessionContext)  = get(λ.sessions, σ.id, missing)
Base.get!(λ::SessionList, σ::SessionContext)  = get!(λ.sessions, σ.id, σ)
Base.push!(λ::SessionList, σ::SessionContext) = push!(λ.sessions, σ.id => σ)
Base.pop!(λ::SessionList, σ::iSessionContext) = pop!(λ.sessions, σ.id, nothing)
Base.in(σ::iSessionContext, λ::SessionList)   = haskey(λ.sessions, σ.id)

struct Application{T} <: iGenericApplication
    sessions :: SessionList
    Application{T}() where {T} = new(fieldtype(Application, :sessions)())
end

Application(func::Function) = Application{func}()

for fcn ∈ (:get, :pop!)
    @eval Base.$fcn(𝐴::iApplication, σ::iSessionContext) = $fcn(sessions(𝐴), σ)
end

Base.in(σ::iSessionContext, 𝐴::iApplication) = σ ∈ sessions(𝐴)
Base.get!(𝐴::iApplication, http::HTTP.Stream) = get!(𝐴, http.message)
Base.get!(𝐴::iApplication, req::HTTP.Request) = get!(𝐴, sessionkey(𝐴, req))

function Base.get!(𝐴::iApplication, 𝑘::iSessionContext; doinit :: Bool = true)
    lst     = sessions(𝐴)
    session = get(lst, 𝑘)
    if ismissing(session)
        session = SessionContext(𝑘)
        doinit && Events.eventlist(𝐴) do
            initialize!(session, 𝐴)
        end
        push!(lst, session)
    end
    return session
end

initializer(::Application{T}) where {T}        = T
url(𝐴::iApplication)                           = "$(nameof(initializer(𝐴)))"
Events.eventlist(::iApplication)               = Events.EventList()
Events.eventlist(𝐹::Function, 𝐴::iApplication) = Events.eventlist(𝐹, Events.eventlist(𝐴))
urlprefix(::iApplication)                      = ""
metadata(::iApplication)                       = "{}"
checktokensignature(::iApplication, token::AbstractString) = Tokens.check(token, CONFIG.secretkey)

"""
    initialize!(::Union{iDocument, SessionContext}, ::iApplication)

Populates a brand new document
"""
function initialize! end

initialize!(σ::SessionContext, 𝐴::Application) = initialize!(σ.doc, 𝐴)
initialize!(𝑑::iDocument, 𝐴::Application)      = initializer(𝐴)(𝑑)

"""
    sessionkey(::iApplication, req::HTTP.Request) = SessionContext(request)

Create a new session, leaving the document empty.
"""
function sessionkey(::iApplication, req::HTTP.Request)
    σ = SessionKey(req)
    Tokens.check(σ.token, CONFIG.secretkey) || httperror("Invalid token or session ID")
    σ
end

sessions(𝐴::iApplication) = 𝐴.sessions

makeid(::iApplication) = "$(UUIDs.uuid4())"
