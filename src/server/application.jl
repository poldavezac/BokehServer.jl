using UUIDs
using ..Events
abstract type iApplication end
abstract type iGenericApplication <: iApplication end

struct SessionList
    sessions :: Dict{String, iSessionContext}
    SessionList() = new(fieldtype(SessionList, :sessions)())
end

Base.get!(list::SessionList, σ::SessionContext)  = get!(list.sessions, σ.id, σ)
Base.pop!(list::SessionList, σ::iSessionContext) = pop!(list.sessions, σ.id, nothing)
Base.in(list::SessionList,   σ::iSessionContext) = haskey(list.sessions, σ.id)

struct Application{T} <: iGenericApplication
    sessions :: SessionList
    Application{T}() where {T} = new(fieldtype(Application, :sessions)())
end

Application(func::Function) = Application{func}()

for fcn ∈ (:get, :pop!)
    @eval Base.$fcn(app::iApplication, σ::iSessionContext) = $fcn(sessions(app), σ)
end

Base.in(σ::iSessionContext, app::iApplication) = σ ∈ sessions(app)
Base.get!(app::iApplication, http::HTTP.Stream) = get!(app, HTTP.request(http))
Base.get!(app::iApplication, req::HTTP.Request) = get!(app, newsession(app, req))

function Base.get!(app::iApplication, session::iSessionContext)
    lst = sessions(app)
    if session ∉ lst
        session = SessionContext(session)
        events  = Events.eventlist(app)
        Events.eventlist(events) do
            initialize!(session.document, app)
            flushevents!(events)
        end
        push!(lst, session)
    end
    return get!(lst, session)
end

initializer(::Application{T}) where {T}       = T
url(x::iApplication)                          = "$(nameof(initializer(x)))"
Events.eventlist(::iApplication)              = Events.EventList()
urlprefix(::iApplication)                     = ""
metadata(::iApplication)                      = "{}"
checktokensignature(::iApplication, ::String) = true

"""
    initialize!(::Document, ::iApplication)

Populates a brand new document
"""
function initialize! end

initialize!(doc::iDocument, app::Application) = initializer(app)(doc)

"""
    newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

Create a new session, leaving the document empty.
"""
newsession(::iApplication, req::HTTP.Request) = BasicSessionContext(request)

sessions(app::iApplication) = app.sessions

makeid(::iApplication) = "$(UUIDs.uuid4())"
