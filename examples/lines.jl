#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehServer

BokehServer.Plotting.serve() do
    fig = BokehServer.figure(x_axis_label = "time", y_axis_label = "energy")
    y   = rand(1:100, 100)
    BokehServer.line!(fig; y, color = :blue)
    BokehServer.scatter!(fig; y, color = :red)

    fig
end
