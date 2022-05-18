module MetadataRoute
using HTTP
using JSON
using ..Server

function route(req::HTTP.Request, app::Server.iApplication)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type" => "application/json")
    HTTP.startwrite(http)
    obj = (; url = Server.applicationurl(app), data = Server.applicationmetadata(app))
    write(http, JSON.json(obj))
end
end
using .MetadataRoute

@route GET metadata MetadataRoute
