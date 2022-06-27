"""
    struct StaticRoute <: iRoute
        roots :: Vector{String}
    end

Provides acces to static files. We find files by iterating through roots and returning
the first successfull path.

Static files can have the following extensions:

* .css: which is a "Content-Type" =>"text/css"
* .gif: which is a "Content-Type" =>"image/gif"
* .ico: which is a "Content-Type" =>"image/x-icon"
* .jpe: which is a "Content-Type" =>"image/jpeg"
* .jpeg: which is a "Content-Type" =>"image/jpeg"
* .jpg: which is a "Content-Type" =>"image/jpeg"
* .js: which is a "Content-Type" =>"text/javascript"
* .pdf: which is a "Content-Type" =>"application/pdf"
* .svg: which is a "Content-Type" =>"image/svg+xml"
* .txt: which is a "Content-Type" =>"text/plain"

with any other extension defaulting to "text/plain".
"""
struct StaticRoute <: iRoute
    roots :: Vector{String}
end

StaticRoute(x::Vararg{AbstractString}) = StaticRoute(collect(String, x))

function route(http::HTTP.Stream, 𝐴::StaticRoute)
    opts = filter!(isfile, joinpath.(𝐴.roots, http.message.target[2:end]))
    if isempty(opts)
        @debug "❌ requested `$(http.message.target[2:end])`"
        fourOfour(http)
    else # not dealing with ambiguities!
        path = opts[1]
        @debug "✅ requested `$path` (1/$(length(opts)) options)"
    
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
        end
    end
end

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::StaticRoute, ::Val) = route(http, 𝐴)

function route(http::HTTP.Stream, ::Val{:GET}, 𝐴::Dict, ::Val{Symbol("favicon.ico")})
    haskey(𝐴, :static) ? route(http, 𝐴[:static]) : fourOfour(http)
end
