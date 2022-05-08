abstract type iApplication end
sessions(app::iApplication) = app.sessions

struct SessionList
    sessions :: Dict{String, SessionContext}
    SessionList() = new(Dict{String, SessionContext()})
end

Base.get!(app::SessionList,  sess::SessionContext) = get!(app.sessions, sess.id, sess)
Base.get!(app::iApplication, sess::SessionContext) = get!(session(app), sess)
Base.pop!(app::SessionList,  sess::SessionContext) = pop!(app.sessions, sess.id, nothing)
Base.pop!(app::iApplication, sess::SessionContext) = pop!(session(app), sess)
Base.in(app::SessionList,    sess::SessionContext) = session.id ∈ keys(app.session)
Base.in(app::iApplication,   sess::SessionContext) = session ∈ app.session

struct Application <: iApplication
    initializer :: Function
    sessions    :: SessionList
    Application(func::Function) = new(func, Dict{String, SessionContext()})
end

urlprefix(::iApplication)           = ""
applicationurl(::iApplication)      = ""
applicationmetadata(::iApplication) = "{}"

"""
    initialize(app::iApplication, doc::iDocument)

Populates a brand new document
"""
function initialize(app::iApplication, doc::iDocument)
    throw(ErrorException("Missing `Bokeh.Server.initialize(::$(typeof(app)), ::Document)`"))
end

"""
    newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

Create a new session, leaving the document empty.
"""
newsession(::iApplication, req::HTTP.Request) = SessionContext(request)

function getsession!(app::iApplication, request::HTTP.Request)
    session = newsession(request)
    (session ∈ app) || Events.eventlist() do
        initialize(app, session.document)
        flushevents!()
    end
    return get!(app, session)
end
