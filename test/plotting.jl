@testset "create figure" begin
    plot = Bokeh.Plotting.figure()
    @test plot isa Bokeh.Models.Plot
    @test nameof.(typeof.(plot.toolbar.tools)) == [
        :PanTool, :WheelZoomTool, :BoxZoomTool,:SaveTool,:ResetTool,:HelpTool
    ]

    plot = Bokeh.Plotting.figure(;
        x_range      = 1:100,
        x_axis_type  = :log,
        x_axis_label = "x axis"
    )
    @test plot.x_range.start ≡ 1.
    @test plot.x_range.finish ≡ 100.
    @test plot.below[end] isa Bokeh.Models.LogAxis
    @test plot.below[end].axis_label == "x axis"

    items = Bokeh.Plotting.getaxis(plot, true)
    @test items.range ≡ plot.x_range
    @test items.scale ≡ plot.x_scale
    @test items.axes  == [plot.below[end]]
    @test length(items.grids) == 1

    Bokeh.Plotting.popaxis!(plot, items; dotrigger = false)

    items = Bokeh.Plotting.getaxis(plot, true)
    @test length(items.axes) == 0
    @test length(items.grids) == 0
end

@testset "create glyph" begin
    plot = Bokeh.Plotting.figure()
    @test isempty(plot.renderers)
    @test !any(i isa Bokeh.Models.Legend for i ∈ plot.center)
    Bokeh.Plotting.glyph!(
        plot, :scatter;
        x            = [1, 2, 3],
        y            = [3, 2, 1],
        legend_label = "label",
        marker       = :x,
        dotrigger    = false,
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa Bokeh.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa Bokeh.Models.Scatter
    @test plot.renderers[1].glyph.marker == :x
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]

    mdls = Bokeh.Model.allmodels(plot)
    @test plot.renderers[1].glyph.id ∈ keys(mdls)
    @test plot.below[end].id ∈ keys(mdls)
    @test plot.left[end].id ∈ keys(mdls)
end
