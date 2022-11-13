using ..BokehServer: bokehconfig
const RouteDict  = Dict{Symbol, iRoute}
const RouteTypes = Union{iRoute, Function, Pair}

"""
    listener(server::HTTP.Sockets.TCPServer, routes::RouteDict)

Return an anonymous function for use with `HTTP.listen`
"""
function listener(server::HTTP.Sockets.TCPServer, routes::RouteDict) :: Function
    (http::HTTP.Stream) -> try
        route(http, routes)
    catch exc
        if exc isa InterruptException
            stop!(routes, server)
            return
        elseif bokehconfig(:throwonerror)
            rethrow()
        end
    end
end

"""
    serve!([host = bokehconfig(:host)], [port = bokehconfig(:port)], apps...; kwa...)

Starts a BokehServer server. `apps` can be `BokehServer.Server.iRoute` types,
functions or pairs of `name_of_app => app_or_function`

# Examples

```julia
BokehServer.Server.serve(
    function myapp(doc::BokehServer.Document)
        ...
    end,
    :mysecondapp => (doc::BokehServer.Document) -> push!(doc, ...)
)
```
"""
function serve!(routes :: RouteDict, host :: AbstractString, port :: Int; kwa...)
    # run routes once to speed-up reaction time once the server has started.
    foreach(precompilemethods, values(routes))

    isempty(routes) || @info(
        "serving applications",
        (i => joinpath("http://$host:$port", "$i") for i ∈ keys(routes))...
    )
    haskey(routes, :static) || push!(routes, staticroutes()...)
    Base.exit_on_sigint(!bokehconfig(:catchsigint))
    server = get(kwa, :server) do
        HTTP.Sockets.listen(HTTP.Sockets.InetAddr(host, port))
    end
    try
        HTTP.listen(listener(server, routes), host, port; kwa..., server)
    catch exc
        (exc isa InterruptException) || rethrow()
    finally
        stop!(routes, server)
    end
end

function stop!(routes::RouteDict, server::HTTP.Sockets.TCPServer)
    if !isopen(server) && isempty(routes)
        return
    end
    @info "stopping the server"
    cpy = collect(values(routes))
    empty!(routes)
    close(server)
    foreach(close, cpy)
end

function serve(host :: AbstractString, port :: Int, apps :: Vararg{RouteTypes}; kwa...)
    serve!(RouteDict(_topair.(apps)...), host, port; kwa...)
end

serve(host::AbstractString, apps::Vararg{RouteTypes}; kwa...) = serve(host, bokehconfig(:port), apps...; kwa...)
serve(port::Int, apps::Vararg{RouteTypes}; kwa...)            = serve(bokehconfig(:host), port, apps...; kwa...)
serve(apps::Vararg{RouteTypes}; kwa...)                       = serve(bokehconfig(:host), bokehconfig(:port), apps...; kwa...)

_topair(@nospecialize(f::Function))                 = nameof(f) => Application(f)
_topair(@nospecialize(f::Pair{Symbol, <:Function})) = f[1]      => Application(f[2])
_topair(@nospecialize(f::Pair{Symbol, <:iRoute}))   = f
