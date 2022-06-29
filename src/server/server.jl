const ROUTES = Dict{Val, iRoute}()

register(app::iRoute, name::Symbol) = register(app, Val(name))
register(func::Function, name)      = register(Application(func), name)
register(func::Function)            = register(Application(func), nameof(func))
function register(app::iRoute, name::Val)
    if !isgoodappname(name) && !isnothing(getapp(ROUTES, nothing))
        @assert false, "Only a single anonymous function is allowed"
    end

    push!(ROUTES, name => app)
end
unregister(name::Val)    = pop!(ROUTES, name, nothing)
unregister(name::Symbol) = pop!(ROUTES, Val(name), nothing)

"""
    @register(functions...)

Adds one or more apps to default apps in `Bokeh.Server.ROUTES`. When starting
a server, these will become available. See `Bokeh.Server.serve`
"""
macro register(funcs...)
    expr = Expr(:block)

    for func ∈ funcs
        line = if func isa Symbol
            :(Bokeh.Server.register($func, $(Val(name))))
        else
            @assert func isa Expr
            @assert func.head ∈ (:call, :(=))
            @assert func.args[1].args[1] isa Symbol
            name = func.args[1].args[1]
            quote
                let func = $func
                    Bokeh.Server.register(func, $(Val(name)))
                end
            end
        end
        push!(expr.args, line)
    end

    expr
end

const RouteTypes = Union{iRoute, Function, Pair}

"""
    serve([host = CONFIG.host], [port = CONFIG.port], apps...; kwa...)

Starts a Bokeh server. `apps` can be `Bokeh.Server.iRoute` types,
functions or pairs of `name_of_app => app_or_function`

# Examples

```julia
# add an app which can be accessed using at `http://localhost:5006/myapp`
@Bokeh.Server.register function myapp(doc::Bokeh.Document)
    ...  anything such as `push!(doc, myroot)`
    return nothing # the return is not used and can be anything
end

# add an app which can be accessed using at `http://localhost:5006/mysecondapp`
@Bokeh.Server.register mysecondapp(doc::Bokeh.Document) = push!(doc, ...)

Bokeh.Server.serve()
```

or even

```julia
Bokeh.Server.serve(
    function myapp(doc::Bokeh.Document)
        ...
    end,
    :mysecondapp => (doc::Bokeh.Document) -> push!(doc, ...)
)
```
"""
function serve(
        host :: AbstractString,
        port :: Int,
        apps :: Vararg{<:RouteTypes};
        kwa...
)
    allapps = typeof(ROUTES)(staticroute(), (isempty(apps) ? ROUTES : _topair.(apps))...)
    @info(
        "serving applications",
        threads = Threads.nthreads(),
        (let root = "http://$host:$port"
            itr = (typeof(k).parameters[1] for k ∈ keys(allapps) if k ≢ Val(:static))
            (i => joinpath(root, "$i") for i ∈ itr)
         end)...
    )
    HTTP.listen(host, port; kwa...) do http::HTTP.Stream
        @debug "Opened new stream: $(http.message.target)"
        try
            http.message.body = readavailable(http)
            closeread(http)
            route(allapps, http)
        catch exc
            route(http, Base.current_exceptions())
            CONFIG.throwonerror && rethrow()
        end
    end
end

serve(host::AbstractString, apps::Vararg{<:RouteTypes}; kwa...) = serve(host, CONFIG.port, apps...; kwa...)
serve(port::Int, apps::Vararg{<:RouteTypes}; kwa...)            = serve(CONFIG.host, port, apps...; kwa...)
serve(apps::Vararg{<:RouteTypes}; kwa...)                       = serve(CONFIG.host, CONFIG.port, apps...; kwa...)

_topair(@nospecialize(f::Function))                 = Val(nameof(f)) => Application(f)
_topair(@nospecialize(f::Pair{<:Val,  <:Function})) = f[1]           => Application(f[2])
_topair(@nospecialize(f::Pair{Symbol, <:Function})) = Val(f[1])      => Application(f[2])
_topair(@nospecialize(f::Pair{Symbol, <:iRoute}))   = Val(f[1])      => f[2]
_topair(@nospecialize(f::Pair{<:Val,  <:iRoute}))   = f[1]           => f[2]

export serve
