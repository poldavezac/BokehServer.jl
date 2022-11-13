module DocRoute
using HTTP
using JSON
using ...BokehServer: bokehconfig
using ...AbstractTypes
using ...Protocol
using ..Documents: Document
using ..Server
using ..Server.Templates

function route(http::HTTP.Stream{HTTP.Request}, app::Server.iRoute)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type" => "text/html")
    HTTP.startwrite(http)
    session = get!(app, http) :: Server.SessionContext
    msg     = body(app, session)
    write(http, msg)
end

Server.staticbundle(app::Server.iApplication) = Server.staticbundle()
Server.staticbundle(app::Server.iStaticRoute) = Server.staticbundle(bokehconfig(:cdn), addversion = true, root = "")

div(::Server.iRoute, roots::Dict{String, String}) = Templates.embed(roots)

function body(app::Server.iStaticRoute, doc::iDocument)
    docid = Server.makeid(app)
    return invoke(
        body,
        Tuple{Server.iRoute, iDocument},
        app,
        doc;
        data = Dict(docid => Protocol.pushdoc(doc).doc),
        docid,
    )
end

body(app::Server.iRoute, session::Server.SessionContext) = body(app, session.doc; session.token)

function body(app::Server.iRoute, doc::iDocument; kwa...)
    bundle  = Server.staticbundle(app)
    rootids = Server.makerootids(app, doc...)
    return filetemplate(
        Templates.docjsscripts(app, rootids; kwa...),
        div(app, rootids),
        doc.title,
        bundle.js_files,
        bundle.js_raw,
        bundle.css_files,
    )
end

function filetemplate(
        plot_script :: AbstractString,
        plot_div    :: AbstractString,
        title       :: AbstractString,
        js_files    :: AbstractVector{<:AbstractString},
        js_raw      :: AbstractVector{<:AbstractString},
        css_files   :: AbstractVector{<:AbstractString},
        langage     :: Symbol = bokehconfig(:language)
)
    css = [
        """<link rel="stylesheet" href="$file" type="text/css" />"""
        for file ∈ css_files
    ]
    js = [
        """<script type="text/javascript" src="$file"></script>"""
        for file ∈ js_files
    ]
    raw = [
        """<script type="text/javascript"> $js </script>"""
        for js ∈ js_raw
    ]
    return """
        <!DOCTYPE html>
        <html lang="$langage">
        <head>
            <meta charset="utf-8">
            <title>$(isempty(title) ? "Bokeh Plot" : title)</title>
            $(join(css, "\n    "))
            $(join(js,  "\n    "))
            $(join(raw, "\n    "))
        </head>
        <body>
            $plot_div
            $plot_script
        </body>
        </html>
        """
end

precompile(body, (Server.Application, Document))
precompile(route, (HTTP.Stream{HTTP.Request}, Server.Application))
end

using .DocRoute

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::iApplication) = DocRoute.route(http, 𝐴)
