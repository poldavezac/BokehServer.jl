#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
push!(LOAD_PATH, joinpath(@__DIR__, "environment"))
using BokehServer
using Pkg.Artifacts
using CSV, DataFrames

const periods = ["I", "II", "III", "IV", "V", "VI", "VII"]
const groups = string.(1:19)


const df = let
    path = joinpath(artifact"javascript", "site-packages", "bokeh", "sampledata", "_data", "elements.csv")

    df   = CSV.read(path, DataFrame)
    df[!, "period"] = [periods[x] for x in df.period]
    df[(df.group .!= "-") .&& (df.symbol .!= "Lr") .&& (df.symbol .!= "Lu"), :]
end

const cmap = Dict(
    "alkali metal"         => "#a6cee3",
    "alkaline earth metal" => "#1f78b4",
    "metal"                => "#d93b43",
    "halogen"              => "#999d9a",
    "metalloid"            => "#e08d49",
    "noble gas"            => "#eaeaea",
    "nonmetal"             => "#f1d4Af",
    "transition metal"     => "#599d7A",
)

const TOOLTIPS = [
    ("Name", "@name"),
    ("Atomic number", "@{atomic number}"),
    ("Atomic mass", "@{atomic mass}"),
    ("Type", "@metal"),
    ("CPK color", "\$color[hex, swatch]:CPK"),
    ("Electronic configuration", "@{electronic configuration}"),
]

BokehServer.serve() do
    p = BokehServer.figure(title="Periodic Table (omitting LA and AC Series)", width=1000, height=450,
                x_range=groups, y_range=collect(periods[end:-1:1]),
               tools="hover", toolbar_location=nothing, tooltips=TOOLTIPS)

    r = BokehServer.rect!(p; x = "group", y = "period", width = 0.95,  height = 0.95,
            source=df, fill_alpha=0.6, legend_field="metal",
            color=BokehServer.Transforms.factor_cmap("metal", collect(values(cmap)), collect(keys(cmap)))
    )

    text_props = (; source=df, text_align=:left, text_baseline=:middle)

    x = BokehServer.Transforms.dodge("group", -0.4, range=p.x_range)

    BokehServer.text!(p; x, y="period", text="symbol", text_font_style="bold", text_props...)

    BokehServer.text!(p; x, y=BokehServer.Transforms.dodge("period", 0.3, range=p.y_range), text="atomic number",
       text_font_size="11px", text_props...)

    BokehServer.text!(p; x, y=BokehServer.Transforms.dodge("period", -0.35, range=p.y_range), text="name",
       text_font_size="7px", text_props...)

    BokehServer.text!(p; x, y=BokehServer.Transforms.dodge("period", -0.2, range=p.y_range), text="atomic mass",
           text_font_size="7px", text_props...)

    BokehServer.text!(p; x=["3", "3"], y=["VI", "VII"], text=["LA", "AC"], text_align="center", text_baseline="middle")

    p.outline_line_color = "#00000000"
    p.grid.grid_line_color = "#00000000"
    p.axis.axis_line_color = "#00000000"
    p.axis.major_tick_line_color = "#00000000"
    p.axis.major_label_standoff = 0
    p.legend.orientation = "horizontal"
    p.legend.location ="top_center"
    p.hover.renderers = [r] # only hover element boxes
    p
end
