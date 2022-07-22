#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
push!(LOAD_PATH, joinpath(@__DIR__, "environment"))
using BokehServer
using StatsBase

BokehServer.Plotting.serve() do
    p = BokehServer.figure(width=670, height=400, toolbar_location=nothing,
               title="Normal (Gaussian) Distribution")

    let n = 1000
        x = randn(Float64, n) .* 12.3 .+ 4.7
        # Scale random data so that it has mean of 0 and standard deviation of 1
        xbar = mean(x)
        sigma = std(x)
        scaled = (x .- xbar) ./ sigma

        # Histogram
        bins = range(-3, 3; length = 40)
        hist, edges = let w = uweights(length(scaled))
            val = fit(Histogram, scaled, w, bins)
            (val.weights, val.edges[1])
        end
        hist = hist ./ sum(hist) .* 6.
        gr = BokehServer.quad!(p; top=hist, bottom=0, left=edges[1:end-1], right=edges[2:end],
                 fill_color="skyblue", line_color="white",
                 legend_label="$n random samples")
    end

    # Probability density function
    let x = range(-3, 3; length = 100)
        pdf = exp.(-0.5 .* (x .^ 2)) ./ √(2π)
        BokehServer.line!(p; x, y = pdf, line_width=2, line_color="navy",
               legend_label="Probability Density Function")
    end
 
    p.y_range.start = 0
    p.xaxis.axis_label = "x"
    p.yaxis.axis_label = "PDF(x)"
 
    p.xaxis.ticker = [-3, -2, -1, 0, 1, 2, 3]
    p.xaxis.major_label_overrides = Dict(
        -3 => BokehServer.Models.TeX(; text = raw"\overline{x} - 3\sigma"),
        -2 => BokehServer.Models.TeX(; text = raw"\overline{x} - 2\sigma"),
        -1 => BokehServer.Models.TeX(; text = raw"\overline{x} - \sigma"),
         0 => BokehServer.Models.TeX(; text = raw"\overline{x}"),
         1 => BokehServer.Models.TeX(; text = raw"\overline{x} + \sigma"),
         2 => BokehServer.Models.TeX(; text = raw"\overline{x} + 2\sigma"),
         3 => BokehServer.Models.TeX(; text = raw"\overline{x} + 3\sigma"),
    )

    p.yaxis.ticker = [0, 0.1, 0.2, 0.3, 0.4]
    p.yaxis.major_label_overrides = Dict(
        0=> BokehServer.Models.TeX(; text = "0"),
        0.1=> BokehServer.Models.TeX(; text = raw"0.1/\sigma"),
        0.2=> BokehServer.Models.TeX(; text = raw"0.2/\sigma"),
        0.3=> BokehServer.Models.TeX(; text = raw"0.3/\sigma"),
        0.4=> BokehServer.Models.TeX(; text = raw"0.4/\sigma"),
    )

    div = BokehServer.Models.Div(text=raw"""
    A histogram of a samples from a Normal (Gaussian) distribution, together with
    the ideal probability density function, given by the equation:
    <p />
    $$
    \qquad PDF(x) = \frac{1}{\sigma\sqrt{2\pi}} \exp\left[-\frac{1}{2}
    \left(\frac{x-\overline{x}}{\sigma}\right)^2 \right]
    $$
    """)

    BokehServer.Models.Column(children = [p, div])
end
