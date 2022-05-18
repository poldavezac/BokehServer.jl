using UUIDs
using ..Events
abstract type iApplication end

struct SessionList
    sessions :: Dict{String, SessionContext}
    SessionList() = new(fieldtype(SessionList, :session)())
end

Base.get!(list::SessionList, σ::SessionContext) = get!(list.sessions, σ.id, σ)
Base.pop!(list::SessionList, σ::SessionContext) = pop!(list.sessions, σ.id, nothing)
Base.in(list::SessionList,   σ::SessionContext) = session.id ∈ keys(list.sessions)

struct Application <: iApplication
    initializer :: Function
    sessions    :: SessionList
    Application(func::Function) = new(fieldtype(Application, :sessions)())
end

for fcn ∈ (:get, :pop!)
    @eval Base.$fcn(app::iApplication, σ::SessionContext) = $fcn(sessions(app), σ)
end

Base.in(σ::SessionContext, app::iApplication) = σ ∈ sessions(app)

Base.get!(app::iApplication, http::HTTP.Stream) = get!(app, HTTP.request(http))
Base.get!(app::iApplication, req::HTTP.Request) = get!(app, newsession(app, req))

function Base.get!(app::iApplication, session::SessionContext)
    lst = sessions(app)
    if session ∉ lst
        events = Events.eventlist(app)
        Events.eventlist(events) do
            initialize!(session.document, app)
            flushevents!(events)
        end
        push!(lst, session)
    end
    return get!(lst, session)
end

Events.eventlist(::iApplication)    = Events.EventList()
urlprefix(::iApplication)           = ""
applicationurl(::iApplication)      = ""
applicationmetadata(::iApplication) = "{}"
checktokensignature(::iApplication, ::String) = true

"""
    initialize!(::Document, ::iApplication)

Populates a brand new document
"""
function initialize! end

initialize!(doc::iDocument, app::Application) = app.func(doc)

"""
    newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

Create a new session, leaving the document empty.
"""
newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

sessions(app::iApplication) = app.sessions

makeid(::iApplication) = "$(UUIDs.uuid4())"
