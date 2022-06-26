function fourOfour(http, ::Any, ::Any, ::Any)
    HTTP.setstatus(http, 404)
    HTTP.setheader(http, "Content-Type"   => "text/plain")
    HTTP.startwrite(http)
    write(http, "Could not find route")
end

function route(http, method::Any, app::Any, key::Any)
    @info "no route found" method app key
    fourOfour(http, method, app, key)
end
