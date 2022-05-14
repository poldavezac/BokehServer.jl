using UUIDs
abstract type iApplication end
sessions(app::iApplication) = app.sessions

struct SessionList
    sessions :: Dict{String, SessionContext}
    SessionList() = new(Dict{String, SessionContext()})
end

Base.get!(list::SessionList, σ::SessionContext) = get!(list.sessions, σ.id, σ)
Base.pop!(list::SessionList, σ::SessionContext) = pop!(list.sessions, σ.id, nothing)
Base.in(list::SessionList,   σ::SessionContext) = session.id ∈ keys(list.sessions)

struct Application <: iApplication
    initializer :: Function
    sessions    :: SessionList
    Application(func::Function) = new(func, SessionList())
end

sessions(app::iApplication) = app.sessions

for fcn ∈ (:get, :pop!)
    @eval Base.$fcn(app::iApplication, σ::SessionContext) = $fcn(sessions(app), σ)
end
Base.in(σ::SessionContext, app::iApplication) = σ ∈ sessions(app)
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
    return get!lst(, session)
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
function initialize end

"""
    newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

Create a new session, leaving the document empty.
"""
newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

makeid(::iApplication) = "$(UUIDs.uuid4())"
