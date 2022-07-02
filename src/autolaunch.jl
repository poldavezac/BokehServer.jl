module AutoLaunch
using UUIDs
using ..AbstractTypes
using ..Server
using ..Plotting
using ..Models

struct AutoLaunchServer
    address :: String
    tcp     :: Server.HTTP.Server
    routes  :: Server.RouteDict
    lastid  :: Ref{String}

    function AutoLaunchServer(host::String = Server.CONFIG.host, port::Int = Server.CONFIG.port)
        routes = Server.RouteDict(Server.staticroutes(Server.CONFIG)...)
        new(
            "$host:$port",
            Server.HTTP.listen!(Server.route(routes), host, port),
            routes,
            Ref(""),
        )
    end
end

const SERVER = Ref{Union{AutoLaunchServer, Nothing}}(nothing)

struct  PlutoApplication <: Server.iApplication
    sessions :: Server.SessionList
    name     :: String
    key      :: UUID
    model    :: iModel

    PlutoApplication(model::iModel) = new(
        Server.SessionList(), Server.makeid(nothing), getplutokey(), model
    )
end

Server.initialize!(𝐷::iDocument, 𝐴::PlutoApplication) = push!(𝐷, 𝐴.model)

function updateserver!(srv::AutoLaunchServer, model::Models.iLayoutDOM)
    header = Server.Templates.headers()
    app    = PlutoApplication(model)
    
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

function lastws(srv::AutoLaunchServer)
    isempty(srv.lastid[]) && return nothing 
    return "ws://$(srv.address)/$(srv.lastid[])/ws"
end

function stopserver!(srv::AutoLaunchServer)
    srv.lastid[] = ""
    vals = collect(values(srv.routes))
    empty!(srv.routes)

    foreach(close, vals)
    close(srv.tcp)
    return nothing
end

function stopserver()
    isnothing(SERVER[]) && return
    srv      = SERVER[]
    SERVER[] = nothing
    stopserver!(srv)
end

lastws() = isnothing(SERVER[]) ? nothing : lastws(SERVER[])

function Base.show(io::IO, 𝑚::MIME"text/html", x::Models.iLayoutDOM)
    isnothing(SERVER[]) && (SERVER[] = AutoLaunchServer())
    return show(io, 𝑚, updateserver!(SERVER[], x))
end

isdeadapp(::Server.iRoute) = false

getplutofield(σ::Symbol, dflt) = isdefined(Main, :PlutoRunner) ? getfield(Main.PlutoRunner, σ) : dflt
isdeadapp(𝐴::PlutoApplication) = haskey(getplutofield(:cell_results, (;)), 𝐴.key)
getplutokey()                  = getplutofield(:currently_running_cell_id, UUID(0))[]
end

using .AutoLaunch
