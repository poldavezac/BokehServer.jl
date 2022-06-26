module MetadataRoute
using HTTP
using JSON
using ..Server

function route(http::HTTP.Stream{HTTP.Request}, app::Server.iApplication)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type" => "application/json")
    HTTP.startwrite(http)
    obj = (; url = Server.url(app), data = Server.metadata(app))
    write(http, JSON.json(obj))
end
end
using .MetadataRoute

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::iApplication, ::Val{:metadata}) = MetadataRoute.route(http, 𝐴)
