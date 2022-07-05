#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehJL

BokehJL.Plotting.serve() do
    fig = BokehJL.figure(x_axis_label = "time", y_axis_label = "energy")
    y   = rand(1:100, 100)
    BokehJL.line!(fig; y, color = :blue)
    BokehJL.scatter!(fig; y, color = :red)

    fig
end
