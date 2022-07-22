"""
Creates a network graph using the given node, edge and layout provider.

Nodes are created using all `node_` keywords. These are passed on to a call to
`BokehServer.Plotting.glyph(BokehServer.Models.Scatter; x...)` (as also occurs in
`BokehServer.scatter!`). One can also provide the `glyph` directly using keyword
`node`.

Edge are created using all `edge_` keywords. These are passed on to a call to
`BokehServer.Plotting.glyph(BokehServer.Models.Multiline; x...)` (as also occurs in
`BokehServer.multiline!`). One can also provide the `glyph` directly using keyword
`edge`.
"""
function graph!(plot :: Models.Plot; layout_provider :: Models.iLayoutProvider, dotrigger :: Bool = true, kw...)
    symb(x, y) = let xx = "$x"
        startswith(xx, y) ? Symbol(xx[length(y)+1:end]) : :_
    end
    symbs(y) = (symb(k, y) =>  v for (k, v) in kw if !isnothing(symb(k, y)))

    rend = let vals = (:name, :level, :visible, :x_range_name, :y_range_name, :selection_policy, :inspection_policy)
        Models.GraphRenderer(;
            layout_provider,
            node_renderer = get(kw, :node) do
                glyph(Models.Scatter; symbs("node_")...)
            end,
            edge_renderer = get(kw, :edge) do
                glyph(Models.MultiLine; symbs("edge_")...)
            end,
            (i for i ∈ kw if first(i) ∈ vals)...
       )
    end
    push!(plot.renderers, rend; dotrigger)
    return rend
end

"""
Creates a network graph using the given node, edge and layout provider.

Nodes are created using all `node_` keywords. These are passed on to a call to
`BokehServer.Plotting.glyph(BokehServer.Models.Scatter; x...)` (as also occurs in
`BokehServer.scatter!`). One can also provide the `glyph` directly using keyword
`node`.

Edge are created using all `edge_` keywords. These are passed on to a call to
`BokehServer.Plotting.glyph(BokehServer.Models.Multiline; x...)` (as also occurs in
`BokehServer.multiline!`). One can also provide the `glyph` directly using keyword
`edge`.
"""
function graph(; layout_provider :: Models.iLayoutProvider, kw...)
    kwargs = (; (k for k ∈ kw if hasfield(Models.FigureOptions, first(k)))...)
    plot   = Plotting.figure(; kwargs...)
    graph!(plot; layout_provider, (i for i ∈ kw if !haskey(kwargs, i))..., dotrigger = false)
    return plot
end

export graph, graph!
