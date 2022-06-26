module DocRoute
using HTTP
using JSON
using ...Bokeh
using ...AbstractTypes
using ..Server
using ..Server.Templates

function route(http::HTTP.Stream{HTTP.Request}, app::Server.iApplication)
    HTTP.setstatus(http, 200)
    HTTP.setheader(http, "Content-Type" => "text/html")
    HTTP.startwrite(http)
    session = get!(app, http)
    msg     = body(app, session)
    write(http, msg)
end

Server.staticbundle(app::Server.iApplication) = Server.staticbundle(Val(:server))

function script(app::Server.iApplication, token::String, roots::Dict{String, String})
    id         = Server.makeid(app)
    plotscript = let json = Templates.scripttag(JSON.json([]); type = "application/json", id)
        json * Templates.scripttag(Templates.onload(Templates.safely(Templates.docjs(
            "document.getElementById('$id').textContent",
            (; token, roots, root_ids = collect(keys(roots)), use_for_title = true)
           ))); id = Server.makeid(app))
    end
end

div(::Server.iApplication, roots::Dict{String, String}) = Templates.embed(roots)

function body(app::Server.iApplication, session::Server.SessionContext)
    bundle = Server.staticbundle(app)
    roots  = Dict{String, String}((
        "$(bokehid(r))" => "$(Server.makeid(app))" for r ∈ session.doc
    )...)
    return filetemplate(
        script(app, session.token, roots),
        div(app, roots),
        session.doc.title,
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
        langage     :: Symbol = Server.CONFIG.language
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

end

using .DocRoute

route(http::HTTP.Stream, ::Val{:GET}, 𝐴::iApplication, ::Val{:?}) = DocRoute.route(http, 𝐴)
