include("routes/autoload.jl")
include("routes/document.jl")
include("routes/metadata.jl")
include("routes/ws.jl")
include("routes/404.jl")
include("routes/redirect.jl")
include("routes/error.jl")
include("routes/static.jl")

function routeargs(apps::Dict{<:Val, <:iRoute}, http)
    method = Val(Symbol(HTTP.method(http.message)))
    name   = missing
    app    = missing
    key    = missing

    path   = Val.(Symbol.(HTTP.URIs.splitpath(HTTP.URI(http.message.target))))
    if isempty(path)
        name = :redirect
        app  = apps
        key  = Val(:?)
    elseif haskey(apps, path[1])
        name = typeof(path[1]).parameters[1]
        app  = apps[path[1]]
        key  = length(path) ≡ 2 ? path[2] : Val(:?)
    elseif length(path) ≡ 1
        name = :redirect
        app  = apps
        key  = path[1]
    end

    return (http, method, app, key)
end

route(apps, http) = route(routeargs(apps, http)...)
