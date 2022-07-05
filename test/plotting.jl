@testset "create figure" begin
    plot = BokehJL.Plotting.figure()
    @test plot isa BokehJL.Models.Plot
    @test nameof.(typeof.(plot.toolbar.tools)) == [
        :PanTool, :WheelZoomTool, :BoxZoomTool,:SaveTool,:ResetTool,:HelpTool
    ]

    plot = BokehJL.Plotting.figure(;
        x_range      = 1:100,
        x_axis_type  = :log,
        x_axis_label = "x axis"
    )
    @test plot.x_range.start ≡ 1.
    @test plot.x_range.finish ≡ 100.
    @test plot.below[end] isa BokehJL.Models.LogAxis
    @test plot.below[end].axis_label == "x axis"

    items = BokehJL.Plotting.getaxis(plot, true)
    @test items.range ≡ plot.x_range
    @test items.scale ≡ plot.x_scale
    @test items.axes  == [plot.below[end]]
    @test length(items.grids) == 1

    BokehJL.Plotting.popaxis!(plot, items; dotrigger = false)

    items = BokehJL.Plotting.getaxis(plot, true)
    @test length(items.axes) == 0
    @test length(items.grids) == 0
end

@testset "create layout" begin
    plt = BokehJL.Models.Plot()
    @assert plt isa BokehJL.Models.iLayoutDOM
    obj = BokehJL.Plotting.layout([plt, plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (1,0,1,1)]

    obj = BokehJL.Plotting.layout([plt, plt]'; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1)]

    obj = BokehJL.Plotting.layout([[plt, plt]', plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 2)]


    obj = BokehJL.Plotting.layout([plt plt; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehJL.Plotting.layout([plt plt]; toolbar_location = :above, dotrigger = false)
    @test obj isa BokehJL.Models.Column
    @test obj.children[2] isa BokehJL.Models.GridBox

    obj = BokehJL.Plotting.layout([plt plt]; toolbar_location = :right, dotrigger = false)
    @test obj isa BokehJL.Models.Row
    @test obj.children[1] isa BokehJL.Models.GridBox
end

@testset "create glyph" begin
    plot = BokehJL.Plotting.figure()
    @test isempty(plot.renderers)
    @test !any(i isa BokehJL.Models.Legend for i ∈ plot.center)
    BokehJL.Plotting.glyph!(
        plot, :scatter;
        x            = [1, 2, 3],
        y            = [3, 2, 1],
        legend_label = "label",
        marker       = :x,
        dotrigger    = false,
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa BokehJL.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehJL.Models.Scatter
    @test plot.renderers[1].glyph.marker == :x
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]

    mdls = BokehJL.Model.allmodels(plot)
    @test plot.renderers[1].glyph.id ∈ keys(mdls)
    @test plot.below[end].id ∈ keys(mdls)
    @test plot.left[end].id ∈ keys(mdls)
end
