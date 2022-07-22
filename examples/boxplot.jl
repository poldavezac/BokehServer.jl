#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehServer
using Random

BokehServer.Plotting.serve() do
    BokehServer.boxplot((let x = [
            ((randn(Float64, 100) .* 3) .+ 10.)...,
            ((randn(Float64, 200) .* 2) .+ 20.)...,
            ((randn(Float64, 300) .* 1) .+ 30.)...,
        ]
        y = [
            ("a" for _ = 1:100)...,
            ("b" for _ = 1:200)...,
            ("c" for _ = 1:300)...,
        ]
        i  = Random.randperm(length(y))
        (y[i], x[i])
    end)...)
end
