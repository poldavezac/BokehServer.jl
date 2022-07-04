module Notebooks
using UUIDs
using ...AbstractTypes
using ...Events
using ...Model
using ...Models
using ...Protocol
using ...Server

struct NotebooksServer
    address :: String
    tcp     :: Server.HTTP.Server
    routes  :: Server.RouteDict
    lastid  :: Ref{String}

    function NotebooksServer(host::String = Server.CONFIG.host, port::Int = Server.CONFIG.port)
        routes = Server.RouteDict(Server.staticroutes(Server.CONFIG)...)
        new(
            "$host:$port",
            Server.HTTP.listen!(Server.route(routes), host, port),
            routes,
            Ref(""),
        )
    end
end

const SERVER = Ref{Union{NotebooksServer, Nothing}}(nothing)

struct  NotebooksApp <: Server.iApplication
    sessions :: Server.SessionList
    name     :: String
    key      :: Union{Nothing, UUID}
    model    :: iModel
    modelids :: Set{Int64}

    NotebooksApp(model::iModel) = new(
        Server.SessionList(), Server.makeid(nothing), getplutokey(),
        model, Model.allids(model)
    )
end

struct NotebooksEventList <: Events.iEventList
    events::Vector{Events.iEvent}
end

Server.initialize!(𝐷::iDocument, 𝐴::NotebooksApp) = push!(𝐷, 𝐴.model; dotrigger = false)

function updateserver!(srv::NotebooksServer, model::Models.iLayoutDOM)
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
    lst = invoke(Events.flushevents!, Tuple{Events.iEventList}, λ)
    isempty(lst) || patchdoc(lst, values(SERVER[].routes))
end

function patchdoc(lst, routes)
    for app ∈ routes
        iscurrentapp(app) && continue

        cpy = copy(app.modelids)

        empty!(app.modelids)
        union!(app.modelids, Model.allids(app.model))

        for sess ∈ values(Server.sessions(app))
            Protocol.patchdoc(lst, sess.doc, cpy, sess.clients...)
        end
    end
end

function Base.show(io::IO, 𝑚::MIME"text/html", x::Models.iLayoutDOM)
    if isnothing(SERVER[])
        SERVER[]        = NotebooksServer()
        Events.EVENTS[] = Events.Deferred{NotebooksEventList}()

        addplutocode()
    end
    return show(io, 𝑚, updateserver!(SERVER[], x))
end

function addplutocode()
    if isdefined(Main, :PlutoRunner) && length(methods(Main.PlutoRunner.show_richest)) == 1
        Main.PlutoRunner.eval(quote
            show_richest(io::IO, v::$(Model.iContainer)) = show_richest(io, v.values)
        end)
    end
end

getplutofield(σ::Symbol, dflt) = isdefined(Main, :PlutoRunner) ? getfield(Main.PlutoRunner, σ) : dflt
isdeadapp(::Server.iRoute)     = (@assert !(Server.iRoute isa NotebooksApp); false)
isdeadapp(𝐴::NotebooksApp)     = haskey(getplutofield(:cell_results, (;)), 𝐴.key)
iscurrentapp(𝐴::Server.iRoute) = (@assert !(Server.iRoute isa NotebooksApp); true)
iscurrentapp(𝐴::NotebooksApp)  = !isnothing(𝐴.key) && getplutokey() == 𝐴.key 
getplutokey()                  = getplutofield(:currently_running_cell_id, Ref(nothing))[]
end

using .Notebooks
