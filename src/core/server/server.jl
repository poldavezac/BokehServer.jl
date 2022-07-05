const RouteDict  = Dict{Symbol, iRoute}
const RouteTypes = Union{iRoute, Function, Pair}

"""
    serve([host = CONFIG.host], [port = CONFIG.port], apps...; kwa...)

Starts a Bokeh server. `apps` can be `Bokeh.Server.iRoute` types,
functions or pairs of `name_of_app => app_or_function`

# Examples

```julia
Bokeh.Server.serve(
    function myapp(doc::Bokeh.Document)
        ...
    end,
    :mysecondapp => (doc::Bokeh.Document) -> push!(doc, ...)
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
    try
        HTTP.listen(route(routes), host, port; kwa...)
    catch exc
        (exc isa InterruptException) || rethrow()
    finally
        foreach(close, values(routes))
    end
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
