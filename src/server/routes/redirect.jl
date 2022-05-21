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
        route(http, nothing, missing, missing)
    else
        uri = HTTP.URI(http.message.target)
        tgt = string(HTTP.URI(;
            uri.scheme,
            uri.host,
            uri.port,
            path = joinpath("/", tostr(name), uri.path),
            uri.query
        ))
        HTTP.set_status(http, 301)
        HTTP.set_header(http, "Location" => tgt)
    end
end

route(http, ::Any, apps::Dict{Val, iApplication}, ::Val) = redirect(http, apps)
