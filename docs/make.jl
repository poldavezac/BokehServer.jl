#!/usr/bin/env -S julia --startup-file=no --history-file=no --project=./docs
using Pkg
Pkg.develop(PackageSpec(path=pwd()))
Pkg.instantiate()

using Documenter
using BokehServer


PATH  = "docs/build/index.html"
REGEX = r"<body>(.*)</body>"s

function addplot(𝐹::Function, key::String; k...)
    @info "plot: $key"
    html = BokehServer.html(browser = false) do
        plot = BokehServer.figure(;
           title            = nothing,
           width            = 300,
           height           = 300,
           min_border       = 0,
           toolbar_location = nothing,
           k...
        )
        𝐹(plot)
        plot
    end

    data = read(PATH, String) 
    open(PATH, "w") do io
        write(io, replace(data, key => match(REGEX, html.content)[1]))
    end
end

makedocs(sitename="BokehServer Documentation")

addplot("ARC") do plt
    x = range(-2, 2, length = 9)
    BokehServer.arc!(
        plt;
        y            = x.^2,
        radius       = x./15. .+ .3,
        start_angle  = 0.6,
        finish_angle = 4.1,
        line_color   = "#8888ee",
        line_width   = 3,
    )
end

addplot("BEZIER") do plt
    x = range(-2, 2, length = 9)
    y = x.^2 
    BokehServer.bezier!(
        plt;
        x0         = x,
        x1         = x.+0.4,
        cx0        = x.+0.1,
        cx1        = x.-0.1,
        y0         = y,
        y1         = y,
        cy0        = y.-0.2,
        cy1        = y.-0.2,
        line_color = "#8888ee",
        line_width = 3,
    )
end

addplot("CIRCLE") do plt
    BokehServer.circle!(plt; y = (1:10).^2, line_color = "#8888ee", line_width = 3)
end

addplot("ELLIPSE") do plt
    x = 1:10
    BokehServer.ellipse!(
        plt;
        x, y = x.^2, width = x ./15.0 .+ 0.3, height = x.^2 ./ 20.0 .+ 0.3,
        line_color = "#8888ee", line_width = 3
    )
end

addplot("BOXPLOT"; x_range = ["x", "y"]) do plt
    labels = [j == 1 ? "x" : "y" for j = 1:2 for _ = 1:(j*10)]
    vals   = [(randn(Float64, 10) .+ 10.)..., (randn(Float64, 20) .- 10.)...]
    BokehServer.boxplot!(plt, labels, vals)
end

addplot("ANNULARWEDGE") do plt
    x = range(-2, 2, length = 9)
    BokehServer.annularwedge!(
        plt;
        x,
        y                = x.^2,
        inner_radius     = 0.2,
        outer_radius     = x./12.0 .+ 0.4,
        start_angle      = 0.6,
        finish_angle     = 4.1,
        fill_color       = "#8888ee",
    )
end

addplot("ANNULUS") do plt
    x = range(-2, 2, length = 9)
    BokehServer.annulus!(
        plt;
        y                = x.^2,
        inner_radius     = 0.2,
        outer_radius     = 0.4,
        fill_color       = "#8888ee",
    )
end


deploydocs(; repo="poldavezac/BokehServer.jl", devbranch = "main")
