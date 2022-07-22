#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehJL
BokehJL.Plotting.serve() do
    fruits = ["Apples", "Pears", "Nectarines", "Plums", "Grapes", "Strawberries"]
    years = ["2015", "2016", "2017"]

    exports = Dict("fruits" => fruits,
               "2015"   => [2, 1, 4, 3, 2, 4],
               "2016"   => [5, 3, 4, 2, 4, 6],
               "2017"   => [3, 2, 4, 4, 5, 3])
    imports = Dict("fruits" => fruits,
               "2015"   => [-1, 0, -1, -3, -2, -1],
               "2016"   => [-2, -1, -3, -1, -2, -2],
               "2017"   => [-1, -2, -1, 0, -2, -2])
    GnBu3 = ["#43a2ca", "#a8ddb5", "#e0f3db"]
    OrRd3 = ["#e34a33", "#fdbb84", "#fee8c8"]

    p = BokehJL.figure(y_range=fruits, height=350, x_range=-16:16, title="Fruit import/export, by year",
               toolbar_location=nothing)

    BokehJL.barstack!(p; x = years, y="fruits", height=0.9, color=GnBu3, source=exports,
        legend_label=["$x exports" for x in years])

    BokehJL.barstack!(p; x = years, y="fruits", height=0.9, color=OrRd3, source=imports,
        legend_label=["$x imports" for x in years])

    p.y_range.range_padding = 0.1
    p.ygrid.grid_line_color = nothing
    p.legend.location = "top_left"
    p.axis.minor_tick_line_color = nothing
    p.outline_line_color = nothing
    p
end
