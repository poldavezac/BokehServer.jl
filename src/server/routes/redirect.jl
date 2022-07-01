function redirect(http, apps)
    name = missing
    for (i, j) ∈ apps
        if j isa iStaticRoute
            continue
        elseif ismissing(name)
            name = "$i"
        elseif "$i"[1] ≢ '#' && name[1] ≡ '#'
            name = "$i"
        end
    end

    if ismissing(name)
        fourOfour(http)
    else
        uri = HTTP.URI(http.message.target)
        tgt = string(HTTP.URI(;
            uri.scheme,
            uri.host,
            uri.port,
            path = joinpath("/", name, uri.path),
            uri.query
        ))
        HTTP.setstatus(http, 301)
        HTTP.setheader(http, "Location" => tgt)
        HTTP.startwrite(http)
    end
end

route(http::HTTP.Stream, apps::RouteDict, ::Val) = redirect(http, apps)
