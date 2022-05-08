module DocRouter
using HTTP
using ...AbstractTypes
using ..Server: iApplication, SessionContext
using ..Server.Templates

function docroute(::Val{:GET}, app::iApplication, session::SessionContext)
    HTTP.Response(
        200,
        ["Content-Type" => "text/html"];
        body    = docbody(app, session),
        request = session.request
    )
end

staticbundle(app::iApplication) = staticbundle(:server)

function doctitle(::iApplication, session::SessionContext)
    title = session.document.title
    return isempty(title) ? CONFIG.title : title
end

function docscript(::iApplication, token::String, roots::Dict{String, String})
    id         = "$(UUIDs.uuid4())"
    plotscript = let json = Templates.scripttag(JSON.json([]); type = "application/json", id)
        script = Templates.scripttag(Templates.onload(Templates.safely(Templates.docjs(
            "document.getElementById('$id').textContent",
            (; token, roots, root_ids = collect(keys(roots)), use_for_title = true)
        ))))
        json + script
    end
end

docdiv(::iApplication, roots::Dict{String, String}) = Templates.embed(roots)

function docbody(app::iApplication, session::SessionContext)
    bundle = staticbundle(app)
    roots  = renderdict(app, Bokeh.iterroots(session.document)...)
    return filetemplate(
        docscript(app, session.token, roots),
        docdiv(app, roots),
        doctitle(app, session),
        bundle.js_files,
        bundle.css_files,
    )
end

function filetemplate(
        plot_script :: AbstractString,
        plot_div    :: AbstractString,
        title       :: AbstractString,
        js_files    :: AbstractVector{<:AbstractString},
        css_files   :: AbstractVector{<:AbstractString},
        langage     :: String = "en"
)
    return """
        <!DOCTYPE html>
        <html lang="$langage">
        <head>
            <meta charset="utf-8">
            <title>$(isempty(title) ? "Bokeh Plot" : title)</title>
            $(join(css_files, "\n    "))
            $(join(js_files,  "\n    "))
        </head>
        <body>
            $plot_div
            $plot_script
        </body>
        </html>
        """
end

export docroute
end
using .DocRouter
