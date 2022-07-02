module MetadataRoute
using HTTP
using JSON
using ..Server

geturl(𝐴::Server.iApplication)  = "$(nameof(𝐴.call))"
metadata(::Server.iApplication) = "{}"

function route(http::HTTP.Stream{HTTP.Request}, app::Server.iApplication)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type" => "application/json")
    HTTP.startwrite(http)
    obj = (; url = geturl(app), data = metadata(app))
    write(http, JSON.json(obj))
end
end
using .MetadataRoute

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::iApplication, ::Val{:metadata}) = MetadataRoute.route(http, 𝐴)
