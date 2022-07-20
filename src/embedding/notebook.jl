module Notebooks
using UUIDs
using HTTP
using ...AbstractTypes
using ...Events
using ...Model
using ...Models
using ...Protocol
using ...Server

struct NotebooksServer
    address :: String
    tcp     :: HTTP.Server
    routes  :: Server.RouteDict
    lastid  :: Ref{String}

    function NotebooksServer(host::String = Server.CONFIG.host, port::Int = Server.CONFIG.port)
        routes = Server.RouteDict(Server.staticroutes(Server.CONFIG)...)
        new(
            "$host:$port",
            let server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(host, port))
                HTTP.listen!(Server.listener(server, routes), host, port; server)
            end,
            routes,
            Ref(""),
        )
    end
end

const SERVER    = Ref{Union{NotebooksServer, Nothing}}(nothing)
const AppModels = Union{Models.iLayoutDOM, Models.ColumnDataSource}

struct  NotebooksApp <: Server.iApplication
    sessions :: Server.SessionList
    name     :: String
    key      :: Union{Nothing, UUID}
    model    :: Models.iLayoutDOM
    modelids :: Set{Int64}

    NotebooksApp(model::Models.iLayoutDOM) = new(
        Server.SessionList(), Server.makeid(nothing), getcurrentcellkey(),
        model, Model.bokehids(model)
    )
end

NotebooksApp(model::Models.ColumnDataSource) = NotebooksApp(Models.DataTable(model))

struct NotebooksEventList <: Events.iEventList
    events::Vector{Events.iEvent}
end

Server.initialize!(𝐷::iDocument, 𝐴::NotebooksApp) = push!(𝐷, 𝐴.model; dotrigger = false)
Server.eventlist(𝐴::NotebooksApp) = NotebooksEventList(Events.iEvent[])

function updateserver!(srv::NotebooksServer, model::AppModels)
    header = Server.Templates.headers()
    app    = NotebooksApp(model)
    
    foreach(keys(filter(isdeadapp∘last, srv.routes))) do name
        close(pop!(srv.routes, name))
    end

    push!(srv.routes, Symbol(app.name) => app)
    srv.lastid[] = app.name

    roots = Server.makerootids(app, model)
    return HTML(
        header
        * Server.Templates.embed(roots)
        * Server.Templates.docjsscripts(
            app,
            Server.Tokens.token(app.name),
            roots;
            use_for_title = false,
            absolute_url  = "http://$(srv.address)",
            app_path      = "/$(app.name)",
            id            = app.name,
        )
    )
end

function lastws(srv::NotebooksServer)
    isempty(srv.lastid[]) && return nothing 
    return "ws://$(srv.address)/$(srv.lastid[])/ws"
end

function stopserver!(srv::NotebooksServer)
    srv.lastid[] = ""
    vals = collect(values(srv.routes))
    empty!(srv.routes)

    foreach(close, vals)
    close(srv.tcp)
    return nothing
end

function stopserver()
    isnothing(SERVER[]) && return
    srv             = SERVER[]
    SERVER[]        = nothing
    Events.EVENTS[] = nothing
    stopserver!(srv)
end

lastws() = isnothing(SERVER[]) ? nothing : lastws(SERVER[])

function Events.flushevents!(λ::NotebooksEventList)
    lst :: Vector{Events.iEvent} = invoke(Events.flushevents!, Tuple{Events.iEventList}, λ)
    isempty(lst) || patchdoc(lst, values(SERVER[].routes))
    return Events.iEvent[] # we've already run all required patchdoc. We don't do it again
end

"""
    cleanroutes!(routes::Dict{Symbol, Server.iRoute})
    cleanroutes!()

Remove closed websockets, sessions with no websockets, applications without sessions
"""
function cleanroutes!(::Dict{Symbol, Server.iRoute})
    for (key, app) ∈ routes
        isnotebookapp(app) && for sess ∈ collect(values(Server.sessions(app)))
            filter!(ws->isopen(ws.io), sess.clients)
            isempty(sess.clients) && pop!(app, sess)
        end
    end
    filter!((x)-> (!isnotebookapp(last(x)) || !isempty(last(x))), routes)
    return nothing
end
cleanroutes!() = isnothing(SERVER[]) || cleanroutes(SERVER[].routes)

function patchdoc(lst :: Vector{Events.iEvent}, routes)
    for app ∈ routes
        isnotebookapp(app) || continue

        cpy = copy(app.modelids)

        empty!(app.modelids)
        union!(app.modelids, Model.bokehids(app.model))

        for sess ∈ values(Server.sessions(app))
            Protocol.patchdoc(lst, sess.doc, cpy, sess.clients...)
        end
    end
end

function Base.show(io::IO, 𝑚::MIME"text/html", x::AppModels)
    notebook()
    return show(io, 𝑚, updateserver!(SERVER[], x))
end

function addplutocode()
    if isdefined(Main, :PlutoRunner) && length(methods(Main.PlutoRunner.show_richest)) == 1
        Main.PlutoRunner.eval(quote
            show_richest(io::IO, v::$(Model.iContainer)) = show_richest(io, v.values)
        end)
    end
end

"""
    notebook(; port = Server.CONFIG.port)

Provides the headers needed for a notebook to display the plots.
Should be returned - and displayed - by a cell prior to displaying plots.

*Note* Needed by `IJulia`, not `Pluto`.
"""
function notebook(; port = Server.CONFIG.port)
    if isnothing(SERVER[])
        Server.CONFIG.port = port
        SERVER[]        = NotebooksServer()
        Events.EVENTS[] = Events.Deferred{NotebooksEventList}()

        addplutocode()
    end

    return HTML("""<img src="http://$(SERVER[].address)/favicon.ico" alt="Started BokehJL">""" * Server.Templates.headers())
end

getplutofield(σ::Symbol, dflt) = isdefined(Main, :PlutoRunner) ? getfield(Main.PlutoRunner, σ) : dflt
isdeadapp(::Server.iRoute)     = (@assert !(Server.iRoute isa NotebooksApp); false)
isdeadapp(𝐴::NotebooksApp)     = !(isnothing(𝐴.key) || haskey(getplutofield(:cell_results, (;)), 𝐴.key))
isnotebookapp(::Server.iRoute) = false
isnotebookapp(::NotebooksApp)  = true
getcurrentcellkey()            = getplutofield(:currently_running_cell_id, Ref(nothing))[]

end

using .Notebooks: notebook
export notebook
