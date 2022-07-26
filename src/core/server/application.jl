using UUIDs

struct SessionList
    sessions :: Dict{String, iSessionContext}
    SessionList() = new(fieldtype(SessionList, :sessions)())
end

Base.isempty(λ::SessionList) = isempty(λ.sessions)
Base.get(λ::SessionList, σ::iSessionContext) :: Union{iSessionContext, Missing} = get(λ.sessions, σ.id, missing)
Base.get!(λ::SessionList, σ::SessionContext) :: SessionContext = get!(λ.sessions, σ.id, σ)
Base.push!(λ::SessionList, σ::SessionContext) = push!(λ.sessions, σ.id => σ)
Base.pop!(λ::SessionList, σ::iSessionContext) = pop!(λ.sessions, σ.id, nothing)
Base.in(σ::iSessionContext, λ::SessionList)   = haskey(λ.sessions, σ.id)
Base.values(λ::SessionList)                   = values(λ.sessions)

function Base.close(λ::SessionList)
    foreach(close, values(λ.sessions))
    empty!(λ.sessions)
end

struct Application <: iApplication
    sessions :: SessionList
    call     :: Function
    Application(call::Function) = new(SessionList(), call)
end

Base.close(𝐴::iApplication) = close(sessions(𝐴))

for fcn ∈ (:get, :pop!)
    @eval Base.$fcn(𝐴::iApplication, σ::iSessionContext) = $fcn(sessions(𝐴), σ)
end

Base.isempty(𝐴::iApplication) = isempty(sessions(𝐴))
Base.in(σ::iSessionContext, 𝐴::iApplication)  = σ ∈ sessions(𝐴)
Base.get!(𝐴::iApplication, http::HTTP.Stream) :: iSessionContext = get!(𝐴, http.message)
Base.get!(𝐴::iApplication, args...)           :: iSessionContext = get!(𝐴, sessionkey(𝐴, args...))

function Base.get!(𝐴::iApplication, 𝑘::iSessionContext; doinit :: Bool = true) :: SessionContext
    lst     = sessions(𝐴)
    session = get(lst, 𝑘) :: Union{iSessionContext, Missing}
    if ismissing(session)
        session = SessionContext(𝑘)
        doinit && Events.eventlist!(𝐴) do
            initialize!(session, 𝐴)
        end
        push!(lst, session)
    end
    return session
end

eventlist(::iApplication)                       = Events.EventList()
Events.eventlist!(𝐹::Function, 𝐴::iApplication) = Events.eventlist!(𝐹, eventlist(𝐴))
checktokensignature(::iApplication, token::AbstractString) = Tokens.check(token, CONFIG.secretkey)

"""
    initialize!(::Union{iDocument, SessionContext}, ::iApplication)

Populates a brand new document
"""
function initialize! end

initialize!(σ::SessionContext, 𝐴::iApplication) = initialize!(σ.doc, 𝐴)
initialize!(𝑑::iDocument,      𝐴::iApplication) = Documents.curdoc!(𝐴.call, 𝑑)

"""
    sessionkey(::iApplication, args...)

Create a new session, leaving the document empty.
"""
function sessionkey(::iApplication, args...)
    σ = SessionKey(args...)
    Tokens.check(σ.token, CONFIG.secretkey) || httperror("Invalid token or session ID")
    σ
end

sessions(𝐴::iApplication) = 𝐴.sessions

makeid(_...) = "$(UUIDs.uuid4())"

function precompilemethods(𝐴::Application)
    Events.eventlist!(Events.NullEventList()) do
        doc = Documents.Document()
        initialize!(doc, 𝐴)
        Protocol.pushdoc("", doc)
    end
end

function makerootids(app::iRoute, rs::Vararg{iModel})
    Dict{String, String}(("$(bokehid(r))" => makeid(app) for r ∈ rs)...)
end
