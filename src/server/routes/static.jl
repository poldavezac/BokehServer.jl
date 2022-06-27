using Pkg.Artifacts
"""
    struct StaticRoute <: iRoute
        route :: Symbol
        paths :: Vector{String}
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
    route :: Symbol
    paths :: Vector{String}
end

StaticRoute(x::Vararg{AbstractString}) = StaticRoute(collect(String, x))

function routefile(http::HTTP.Stream, path::AbstractString)
    routefile(http, splitext(path)[end], read(path, String))
end

function routefile(http::HTTP.Stream, ext::AbstractString, data::AbstractString)
    HTTP.setstatus(http, 200)
    tpe = ext == ".css" ? "text/css"        :
        ext == ".gif"   ? "image/gif"       :
        ext == ".ico"   ? "image/x-icon"    :
        ext == ".jpe"   ? "image/jpeg"      :
        ext == ".jpeg"  ? "image/jpeg"      :
        ext == ".jpg"   ? "image/jpeg"      :
        ext == ".js"    ? "text/javascript" :
        ext == ".pdf"   ? "application/pdf" :
        ext == ".svg"   ? "image/svg+xml"   :
        ext == ".txt"   ? "text/plain"      :
        "text/plain"

    HTTP.setheader(http, "Content-Type"   => tpe)
    HTTP.setheader(http, "Content-Length" => string(length(data)))
    HTTP.startwrite(http)
    write(http, data)
end

function route(http::HTTP.Stream, 𝐴::StaticRoute, tgt::AbstractString = http.message.target)
    len = length("/$(𝐴.route)/")+1
    for root ∈ 𝐴.paths
        path = joinpath(root, tgt[len:end])
        if isfile(path)
            @debug "✅ requested `$path`"
            routefile(http, path)
            return
        end
    end

    @debug "❌ requested `$tgt`"
    fourOfour(http)
end

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::StaticRoute, ::Val) = route(http, 𝐴)

function route(http::HTTP.Stream, ::Val{:GET}, ::Dict, ::Val{Symbol("favicon.ico")})
    routefile(http, joinpath(artifact"javascript", "favicon.ico"))
end

staticroute(cnf = Server.CONFIG) = (Val(cnf.staticroute) => StaticRoute(cnf.staticroute, cnf.staticpaths))
