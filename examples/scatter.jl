#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using Bokeh.Plotting

Plotting.serve() do
    Plotting.scatter(x = 1:10, y = 10. : -1. : 1., legend_label= "this is a label")
end
