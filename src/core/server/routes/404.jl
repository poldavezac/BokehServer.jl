function fourOfour(http, _...)
    HTTP.setstatus(http, 404)
    HTTP.setheader(http, "Content-Type" => "text/plain")
    HTTP.startwrite(http)
    write(http, "Could not find route")
end

function route(http::HTTP.Stream, ::Val)
    @info "no route found" target = http.message.target
    fourOfour(http)
end
