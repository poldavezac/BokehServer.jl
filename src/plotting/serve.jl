"""
    serve(𝐹::Function, [host = "localhost"], [port = 5006]; [name = :plot], k...)

Serves a figure at address `host:port/name`
The function can take:
* no argument, in which case the returned oject(s) will automatically be added
to the document, should the latter be left empty.
* a `Document`, in which case the returned oject(s) will automatically be added
to the document, should the latter be left empty.

# examples

```julia
BokehServer.serve() do
    BokehServer.scatter(x = 1:10, y = 10. : -1. : 1.)
end
```

```julia
BokehServer.serve() do doc::BokehServer.Document
    fig = BokehServer.figure()
    BokehServer.scatter!(fig; x = 1:10, y = 10. : -1. : 1.)
    push!(doc, fig)
end
```
"""
function serve(𝐹::Function, a...; k...)
    function plot(doc::iDocument)
        out = if applicable(𝐹)
            𝐹()
        elseif applicable(𝐹, doc)
            𝐹(doc)
        end

        isempty(doc.roots) && if out isa iModel
            push!(doc, out)
        elseif applicable(filter, out)
            push!(doc, filter(Base.Fix2(isa, Models.iLayoutDOM), out)...)
        end
        isempty(doc.roots) && @warn "Did you forget to return a plot?"
        doc
    end

    Server.serve(plot, a...; k...)
end

"""
    serve(
        plot::iLayoutDOM,
        [host = "localhost"],
        [port = 5006];
        name  = :plot,
        title = "Bokeh Plot",
        k...
    )

Serve a plot or layout.

This is similar to calling:

```julia
myplot = scatter(rand(Float64, 100))
title  = "My beloved scatter"

serve() do doc :: BokehServer.Document
    push!(doc, myplot)
    doc.title = title
end
```
"""
function serve(plot::Models.iLayoutDOM, a...; title = "Bokeh Plot", k...)
    return serve(a...; k...) do doc :: Document
        push!(doc, plot)
        doc.title = title
    end
end

export serve
