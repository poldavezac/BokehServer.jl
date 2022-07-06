const RouteDict  = Dict{Symbol, iRoute}
const RouteTypes = Union{iRoute, Function, Pair}

"""
    serve([host = CONFIG.host], [port = CONFIG.port], apps...; kwa...)

Starts a BokehJL server. `apps` can be `BokehJL.Server.iRoute` types,
functions or pairs of `name_of_app => app_or_function`

# Examples

```julia
BokehJL.Server.serve(
    function myapp(doc::BokehJL.Document)
        ...
    end,
    :mysecondapp => (doc::BokehJL.Document) -> push!(doc, ...)
)
```
"""
function serve!(routes :: RouteDict, host :: AbstractString, port :: Int; kwa...)
    isempty(routes) || @info(
        "serving applications",
        (i => joinpath("http://$host:$port", "$i") for i ∈ keys(routes))...
    )
    haskey(routes, :static) || push!(routes, staticroutes(CONFIG)...)
    Base.exit_on_sigint(!CONFIG.catchsigint)
    server = HTTP.Sockets.listen(HTTP.Sockets.InetAddr(host, port))
    try
        HTTP.listen(host, port; kwa..., server) do http::HTTP.Stream
            try
                route(http, routes)
            catch exc
                if exc isa InterruptException
                    stop!(routes, server)
                    return
                elseif CONFIG.throwonerror
                    rethrow()
                end
            end
        end
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

function serve(host :: AbstractString, port :: Int, apps :: Vararg{<:RouteTypes}; kwa...)
    serve!(RouteDict(_topair.(apps)...), host, port; kwa...)
end

serve(host::AbstractString, apps::Vararg{<:RouteTypes}; kwa...) = serve(host, CONFIG.port, apps...; kwa...)
serve(port::Int, apps::Vararg{<:RouteTypes}; kwa...)            = serve(CONFIG.host, port, apps...; kwa...)
serve(apps::Vararg{<:RouteTypes}; kwa...)                       = serve(CONFIG.host, CONFIG.port, apps...; kwa...)

_topair(@nospecialize(f::Function))                 = nameof(f) => Application(f)
_topair(@nospecialize(f::Pair{Symbol, <:Function})) = f[1]      => Application(f[2])
_topair(@nospecialize(f::Pair{Symbol, <:iRoute}))   = f

export serve
