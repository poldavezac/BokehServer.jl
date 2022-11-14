using Plots

@testset "plots backend" begin
    bokeh()
    crt = BokehServer.figure
    @test crt(plot([0, 1])).renderers[1].glyph isa BokehServer.Line 
    @test crt(plot([0, 1], [0, 1])).renderers[1].glyph isa BokehServer.Line 
    @test crt(scatter([0, 1], [0, 1])).renderers[1].glyph isa BokehServer.Scatter
    @test (
        crt(
            plot(sin, (x-> sin(2x)), 0, 2π, line = 4, leg = false, fill = (0, :orange))
        ).renderers[2].glyph isa BokehServer.HArea
    )
    @test crt(scatter(
        fill(randn(10), 6),
        fill(randn(10), 6),
        framestyle = [:box :semi :origin :zerolines :grid :none],
        title = [":box" ":semi" ":origin" ":zerolines" ":grid" ":none"],
        color = permutedims(1:6),
        layout = 6, label = "", markerstrokewidth = 0, ticks = -2:2
       )) isa BokehServer.GridPlot
    @test crt(
        histogram(randn(1000), bins = :scott, weights = repeat(1:5, outer = 200), linestyle=:dotted, fillalpha=0.)
    ).renderers[1].glyph isa BokehServer.VBar
    @test crt(histogram2d(randn(10000), randn(10000), nbins = 20)).renderers[1].glyph isa BokehServer.Rect
    @test crt(hexbin(randn(10_000), randn(10_000))).renderers[1].glyph isa BokehServer.HexTile
    @test crt(heatmap(["1","2","3"],["1","2","3"],[1 2 3;2 3 1;3 1 1])).renderers[1].glyph isa BokehServer.Rect
    @test crt(begin
        y = rand(20, 3)
        plot(y, xaxis = ("XLABEL", (-5, 30), 0:2:20, :flip), leg = false)
        hline!(sum(y, dims = 1) ./ size(y, 1) + rand(1, 3), line = (4, :dash, 0.6, [:lightgreen :green :darkgreen]))
        vline!([5, 10])
        title!("TITLE")
        yaxis!("YLABEL", :log10, minorgrid = true)
    end).center[end] isa BokehServer.Span
end

