module Htmls
using ...AbstractTypes
using ...Documents
using ...Events
using ...Models
using ...Server
using ...BokehServer: bokehconfig

struct Standalone <: Server.iStaticRoute end

"""
    html(
        𝐹       :: Union{Function, iLayoutDOM};
        title   :: AbstractString = "Bokeh Plot",
        browser :: Bool           = true,
        path    :: AbstractString = "",
        k...
    )
    html(
        doc     :: iDocument;
        browser :: Bool           = true,
        path    :: AbstractString = "",
        k...
    )

Create an HTML page, either by providing a document or a function
returning a plot or a layout.

The default browser is launched if `browser = true`.
The file is saved to `path` if the latter is not empty.

```julia
BokehServer.Plotting.html(; title = "my favorite plot") do
    BokehServer.scatter(; x = randn(Float64, 100), y = randn(Float64, 100))
end
```
"""
function html(𝐹::Function; title :: AbstractString = "Bokeh Plot", k...) :: Union{HTML, Nothing}
    doc = Documents.Document(; title)
    Events.eventlist!(Events.NullEventList()) do
        out = Documents.curdoc!(doc) do
            if applicable(𝐹)
                𝐹()
            elseif applicable(𝐹, iDocument)
                𝐹(doc)
            elseif applicable(𝐹, Models.Plot)
                fig = Model.Plot()
                𝐹(fig)
                fig
            end
        end

        if out isa iDocument
            doc = out
        elseif isempty(doc.roots)
            if out isa iModel
                push!(doc, out)
            elseif applicable(filter, out)
                push!(doc, filter(Base.Fix2(isa, Models.iLayoutDOM), out)...)
            end
        end
    end
    isempty(doc.roots) && @warn "Did you forget to return a plot?"

    return html(doc; k...)
end

function html(plot::Models.iLayoutDOM; title :: AbstractString = "Bokeh Plot", k...) :: Union{HTML, Nothing}
    return html(Documents.Document(; roots = [plot], title); k...)
end

function html(
        doc     :: iDocument;
        browser :: Bool                = true,
        path    :: AbstractString      = browser ? bokehconfig(:html_path) : "",
        app     :: Server.iStaticRoute = Standalone(),
        k...
) :: Union{Nothing, HTML}
    body = Server.DocRoute.body(app, doc)
    isempty(path) || open(Base.Fix2(write, body), path, "w")
    browser       && open_in_default_browser(path)
    return isempty(path) ? HTML(body) : nothing
end

# from https://github.com/JuliaLang/julia/pull/36425
function detectwsl()
    Sys.islinux() &&
    isfile("/proc/sys/kernel/osrelease") &&
    occursin(r"Microsoft|WSL"i, read("/proc/sys/kernel/osrelease", String))
end

# from Pluto
function open_in_default_browser(url::AbstractString)::Bool
    try
        if Sys.isapple()
            Base.run(`open $url`)
            true
        elseif Sys.iswindows() || detectwsl()
            Base.run(`powershell.exe Start "'$url'"`)
            true
        elseif Sys.islinux()
            Base.run(`xdg-open $url`)
            true
        else
            false
        end
    catch ex
        false
    end
end

precompile(html, (Function,))
precompile(html, (Documents.Document,))
end

using .Htmls: html
export html
