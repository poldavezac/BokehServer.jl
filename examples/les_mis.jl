#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehJL
using BokehJL.Model.JSON
using Pkg.Artifacts
path   = joinpath(artifact"javascript", "site-packages", "bokeh", "sampledata", "_data", "les_mis.json")
data   = JSON.parse(read(path, String))
nodes  = data["nodes"]
names  = getindex.(sort(nodes, by = x-> x["group"]), "name")
counts = zeros(Float64, (length(nodes), length(nodes)))
for link ∈ data["links"]
    counts[link["source"]+1, link["target"]+1] = link["value"]
    counts[link["target"]+1, link["source"]+1] = link["value"]
end

colormap = [
    "#444444", "#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99",
    "#E31A1C", "#FDBF6F", "#FF7F00", "#CAB2D6", "#6A3D9A"
]

xname = String[]
yname = String[]
color = String[]
alpha = Float64[]
dflt  = BokehJL.Model.colorhex(:lightgrey)
for (i, node1) ∈ enumerate(nodes), (j, node2) ∈ enumerate(nodes)
    push!(xname, node1["name"])
    push!(yname, node2["name"])

    push!(alpha, min(counts[i,j]/4.0, 0.9) + 0.1)
    push!(color, node1["group"] == node2["group"] ? colormap[node1["group"]+1] : dflt)
end

data = Dict(
    "xname" => xname,
    "yname" => yname,
    "colors" => color,
    "alphas" => alpha,
    "count" => reshape(counts, :),
)

BokehJL.Plotting.serve() do
    fig = BokehJL.figure(;
        title           = "Les Mis Occurrences",
        x_axis_location = "above",
        tools           = "hover,save",
        x_range         = names[end:-1:1],
        y_range         = names,
        tooltips        = [("names", "@yname, @xname"), ("count", "@count")],
        width           = 800,
        height          = 800
    )
    BokehJL.rect!(
        fig;
        x                = "xname",
        y                = "yname",
        width            = 0.9,
        height           = 0.9,
        source           = data,
        fill_color       = "colors",
        alpha            = "alphas",
        line_color       = nothing,
        hover_line_color = "black",
        hover_color      = "colors"
    )

    xaxis = BokehJL.getaxis(fig, :x)
    yaxis = BokehJL.getaxis(fig, :y)
    for grid ∈ Iterators.flatten(i.grids for i ∈ (xaxis, yaxis))
        grid.grid_line_color = nothing
    end

    for axis ∈ Iterators.flatten(i.axes for i ∈ (xaxis, yaxis))
        axis.axis_line_color        = nothing
        axis.major_tick_line_color  = nothing
        axis.major_label_text_font_size = "7px"
        axis.major_label_standoff       = 0
    end
    for axis ∈ xaxis.axes
        axis.major_label_orientation   = π/3
    end
    fig
end
