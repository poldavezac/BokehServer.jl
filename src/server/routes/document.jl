module DocRouter
using HTTP
using ...AbstractTypes
using ..Server
using ..Server.Templates

function docroute(::Val{:GET}, app::iApplication, session::SessionContext)
    HTTP.Response(
        200,
        ["Content-Type" => "text/html"];
        body    = docbody(app, session)
        request = session.request
    )
end

staticbundle(app::iApplication) = staticbundle(:server)

function doctitle(::iApplication, session::SessionContext)
    title = session.document.title
    return isempty(title) ? Config.TITLE : title
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
        bundle.bokeh_js,
        bundle.bokeh_css,
    )
end

function filetemplate(
        plot_script :: AbstractString,
        plot_div    :: AbstractString,
        title       :: AbstractString,
        bokeh_js    :: AbstractVector{<:AbstractString},
        bokeh_css   :: AbstractVector{<:AbstractString},
        langage     :: String = "en"
)
    return """
        <!DOCTYPE html>
        <html lang="$langage">
        <head>
            <meta charset="utf-8">
            <title>$(isempty(title) ? "Bokeh Plot" : title)</title>
            $(join(bokeh_css, "\n    "))
            $(join(bokeh_js,  "\n    "))
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
