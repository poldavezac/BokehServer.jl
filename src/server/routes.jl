macro route(method, basename, code)
    (basename isa String) && (basename = Symbol(basename))
    params = (
        :(http::HTTP.Stream),
        :(::$(Val{method})),
        :(app::Union{Missing, iApplication}),
        :(::$(Val{basename}))
    )
    return if code isa Symbol
        :(route($(params...)) = $code.route(http, app))
    else
        :(route($(params...)) = $code)
    end
end

include("routes/autoload.jl")
include("routes/document.jl")
include("routes/metadata.jl")
include("routes/ws.jl")
include("routes/static.jl")

function routeargs(apps::Dict{<:Val, <:Union{Missing,iApplication}}, http)
    method = Val(Symbol(HTTP.method(http.request)))
    app    = missing
    key    = Val(:404)

    path   = Val.(Symbol.(HTTP.URIs.splitpath(HTTP.URI(http.request.target))))
    if isempty(path)
        for (i, j) ∈ apps
            if i ≡ Val(:static)
                continue
            elseif "$(typeof(i).parameters[1])"[1] ≡ '#'
                app = j
            elseif ismissing(app)
                app = j
            end
        end
        ismissing(app) || (key = Val(:?))
    elseif haskey(apps, path[1])
        app = get(apps, path[1])
        key = length(path) ≡ 2 ? path[2] : Val(:?)
    end

    return if applicable(route, http, method, app, key)
        (http, method, app, key)
    else
        (http, method, missing, Val(:404))
    end
end

route(apps, http) = route(routeargs(apps, http)...)
