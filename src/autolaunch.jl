module AutoLaunch
using ..AbstractTypes
using ..Server
using ..Plotting
using ..Models

struct AutoLaunchServer
    address :: String
    tcp     :: Server.HTTP.Sockets.TCPServer
    routes  :: Server.RouteDict
    lastid  :: Ref{String}

end

const SERVER = Ref{Union{Tuple{Task, AutoLaunchServer}, Nothing}}(nothing)

function startserver(host::String = Server.CONFIG.host, port::Int = Server.CONFIG.port)
    srv = AutoLaunchServer(
        "$host:$port",
        Server.HTTP.Sockets.listen(Server.HTTP.Sockets.InetAddr(host, port)),
        Server.RouteDict(),
        Ref("")
    )
    task = @async try
        Server.serve!(srv.routes, host, port; server = srv.tcp)
    catch exc
        @error "AutolaunchServer error" exception = (exc, Base.catch_backtrace())
    end
    sleep(.01) # launch the server please!
    @assert istaskstarted(task)
    @assert !istaskdone(task)
    return (task, srv)
end

function updateserver!(srv::AutoLaunchServer, model::Models.iLayoutDOM)
    header = Server.Templates.headers()
    app    = Server.Application(Base.Fix2(push!, model))
    id     = makedocid(app)
    token  = srv.lastid[] = Server.SessionKey(id, nothing).token
    
    foreach(filter(iskeyalive, keys(srv.routes))) do key::Symbol
        close(pop!(srv.routes, key))
    end

    push!(srv.routes, Symbol(id) => app)

    roots = Server.makerootids(app, model)
    return HTML(
        header
        * Server.Templates.embed(roots)
        * Server.Templates.docjsscripts(
            app, token, roots;
            use_for_title = false,
            absolute_url  = "http://$(srv.address)",
            app_path      = "/$id",
            id,
        )
    )
end

function lastws(srv::AutoLaunchServer)
    isempty(srv.lastid[]) && return nothing 
    return "ws://$(srv.address)/$(Server.Tokens.sessionid(srv.lastid[]))/ws"
end

function stopserver!(srv::AutoLaunchServer)
    foreach(close, values(srv.routes))
    empty!(srv.routes)
    close(srv.tcp)
    srv.lastid[] = ""
    return nothing
end

function stopserver()
    isnothing(SERVER[]) && return
    (task, srv) = SERVER[]
    SERVER[]    = nothing
    stopserver!(srv)
    wait(task)
end

lastws() = isnothing(SERVER[]) ? nothing : lastws(SERVER[][2])

if isdefined(Main, :PlutoRunner)
    iskeyalive(key::Symbol) = haskey(Main.PlutoRunner.cell_results, "$key"[6:end]) 
    makedocid(_)            = "bokeh$(Main.PlutoRunner.currently_running_cell_id[])"
else
    iskeyalive(_)  = true
    makedocid(app) = Server.makeid(app)
end

function Base.show(io::IO, 𝑚::MIME"text/html", x::Models.iLayoutDOM)
    (isnothing(SERVER[]) || istaskdone(SERVER[][1])) && (SERVER[] = startserver())
    return show(io, 𝑚, updateserver!(SERVER[][2], x))
end

end

using .AutoLaunch
