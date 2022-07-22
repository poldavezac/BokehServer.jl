#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehJL

BokehJL.Plotting.serve() do
    BokehJL.scatter(x = 1:10, y = 10. : -1. : 1., legend_label= "this is a label")
end
