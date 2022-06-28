function redirect(http, apps::Dict)
    tostr(x::Val) = "$(typeof(x).parameters[1])"
    name = missing
    for (i, j) ∈ apps
        if i ≡ Val(:static)
            continue
        elseif tostr(i)[1] ≡ '#'
            name = i
        elseif ismissing(name)
            name = i
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
            path = joinpath("/", tostr(name), uri.path),
            uri.query
        ))
        HTTP.setstatus(http, 301)
        HTTP.setheader(http, "Location" => tgt)
        HTTP.startwrite(http)
    end
end

route(http, ::Any, apps::Dict{Val, iRoute}, ::Val) = redirect(http, apps)
