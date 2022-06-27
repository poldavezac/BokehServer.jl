struct StaticRoute <: iRoute
    root :: String
end

function route(http::HTTP.Stream, 𝐴::StaticRoute)
    path = joinpath(𝐴.root, http.message.target[2:end])
    @debug "$(isfile(path) ? "✅" : "❌") requested `$(path)`"
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

        HTTP.setheader(http, "Content-Type"   => tpe)
        HTTP.setheader(http, "Content-Length" => string(filesize(path)))
        HTTP.startwrite(http)
        write(http, read(path, String))
    else
        fourOfour(http)
    end
end

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::StaticRoute, ::Val) = route(http, 𝐴)

function route(http::HTTP.Stream, ::Val{:GET}, 𝐴::Dict, ::Val{Symbol("favicon.ico")})
    haskey(𝐴, :static) ? route(http, 𝐴[:static]) : fourOfour(http)
end
