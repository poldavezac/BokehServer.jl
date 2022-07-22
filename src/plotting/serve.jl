"""
    serve(𝐹::Function, [host = "localhost"], [port = 5006]; [name = :plot], k...)
    serve([host = "localhost"], [port = 5006], apps...; k...)

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
Plotting.serve() do fig::Plotting.Plot
    Plotting.scatter!(fig; x = 1:10, y = 10. : -1. : 1.)
end
```

```julia
Plotting.serve() do
    Plotting.scatter(x = 1:10, y = 10. : -1. : 1.)
end
```

```julia
Plotting.serve() do doc::Plotting.Document
    fig = Plotting.figure()
    Plotting.scatter!(fig; x = 1:10, y = 10. : -1. : 1.)
    push!(doc, fig)
end
```
"""
function serve(𝐹::Function, a...; k...)
    function plot(doc::iDocument)
        out = if applicable(𝐹)
            𝐹()
        elseif applicable(𝐹, Union{Document, iDocument})
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
