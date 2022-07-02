include("routes/autoload.jl")
include("routes/document.jl")
include("routes/metadata.jl")
include("routes/ws.jl")
include("routes/404.jl")
include("routes/redirect.jl")
include("routes/error.jl")
include("routes/static.jl")

function route(http::HTTP.Stream, routes::RouteDict)
    @debug "Opened new stream: $(http.message.target)"
    try
        http.message.body = readavailable(http)
        closeread(http)

        path = Symbol.(HTTP.URIs.splitpath(HTTP.URI(http.message.target)))
        if isempty(path)
            # Redirect to main app ?
            # Hijack the route by adding a `Server.route(::HTTP.Stream, :RouteDict, ::Val{:redirect})`
            route(http, routes, Val(:redirect))
        elseif haskey(routes, path[1])
            # found an app, we deal with it
            method = Val(Symbol(HTTP.method(http.message)))
            route(http, method, routes[path[1]], Val.(path[2:end])...)
        else
            # Unknonw path
            # Hijack the route by adding a `Server.route(::HTTP.Stream, ::Val{:404})`
            route(http, Val(:404))
        end
    catch exc
        route(http, Base.current_exceptions())
        CONFIG.throwonerror && rethrow()
    end
end

route(routes::RouteDict) = Base.Fix2(route, routes)
