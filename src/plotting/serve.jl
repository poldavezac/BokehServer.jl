"""
    serve(𝐹::Function, [host = "localhost"], [port = 5006]; [name = :plot], k...)

Serves a figure at address `host:port/name`
The function can take:
* no argument, in which case the returned oject(s) will automatically be added
to the document, should the latter be left empty.
* a `Document`, in which case the returned oject(s) will automatically be added
to the document, should the latter be left empty.
* a `Plot`, in which case a `Plot` is created and then added to the document,
should the latter be left empty.

# examples

```julia
BokehServer.serve() do fig::BokehServer.Plot
    .scatter!(fig; x = 1:10, y = 10. : -1. : 1.)
end
```

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
        elseif applicable(𝐹, iDocument)
            𝐹(doc)
        elseif applicable(𝐹, Models.Plot)
            fig = Model.Plot()
            𝐹(fig)
            fig
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
export serve
