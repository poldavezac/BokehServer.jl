module StaticRoute
using HTTP
using ...AbstractTypes
using ..Server
using ..Templates

function route(http::HTTP.Stream, root::String)
    uri  = HTTP.URI(http.request.target)
    path = joinpath(root, uri.path)
    if isfile(path)
        HTTP.setstatus(http, 200)
        ext = splitext(path)[end]
        tpe = ext ≡ "css" ? "text/css"        :
            ext ≡ "gif"   ? "image/gif"       :
            ext ≡ "ico"   ? "image/x-icon"    :
            ext ≡ "jpe"   ? "image/jpeg"      :
            ext ≡ "jpeg"  ? "image/jpeg"      :
            ext ≡ "jpg"   ? "image/jpeg"      :
            ext ≡ "js"    ? "text/javascript" :
            ext ≡ "pdf"   ? "application/pdf" :
            ext ≡ "svg"   ? "image/svg+xml"   :
            ext ≡ "txt"   ? "text/plain"      :
            "text/plain"

        HTTP.setheader(
            http,
            "Content-Type"   => tpe,
            "Content-Length" => string(filesize(path))
        )
        HTTP.startwrite(http)
        write(http, read(path, String))
    else
        HTTP.setstatus(http, 404)
    end
end
end
using .StaticRoute

@route GET static StaticRoute.route(http, Server.CONFIG.staticpath)
