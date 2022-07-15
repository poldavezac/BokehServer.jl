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

    items = BokehJL.Plotting.getaxis(plot, :x)
    @test items.range ≡ plot.x_range
    @test items.scale ≡ plot.x_scale
    @test items.axes  == [plot.below[end]]
    @test length(items.grids) == 1

    BokehJL.Plotting.popaxis!(plot, items; dotrigger = false)

    items = BokehJL.Plotting.getaxis(plot, :x)
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

    obj = BokehJL.Plotting.layout([nothing plt; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,1,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehJL.Plotting.layout([plt plt; plt nothing]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 1)]

    obj = BokehJL.Plotting.layout([plt nothing; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehJL.Plotting.layout([plt plt; nothing plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 1, 1, 1)]

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
    BokehJL.Plotting.scatter!(
        plot;
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

    mdls = BokehJL.Model.bokehmodels(plot)
    @test plot.renderers[1].glyph.id ∈ keys(mdls)
    @test plot.below[end].id ∈ keys(mdls)
    @test plot.left[end].id ∈ keys(mdls)
end

@testset "create rect" begin
    plot = BokehJL.Plotting.figure()
    @test isempty(plot.renderers)
    @test !any(i isa BokehJL.Models.Legend for i ∈ plot.center)
    BokehJL.rect!(
        plot;
        x            = [1, 2, 3],
        y            = [3, 2, 1],
        height       = .5,
        width        = .8,
        color        = [:blue, :red, :green],
        legend_label = "label",
        dotrigger    = false,
        hover_color  = "#00FF00FF",
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa BokehJL.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehJL.Models.Rect
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]
    @test plot.renderers[1].data_source.data["color"] == ["#0000FF", "#FF0000", "#008000"]
    @test plot.renderers[1].glyph.fill_color == "color"
    @test plot.renderers[1].glyph.hatch_color == "color"
    @test plot.renderers[1].hover_glyph.hatch_color == "#00FF00"
    @test plot.renderers[1].hover_glyph.fill_color == "#00FF00"
end

@testset "create line" begin
    @test isempty(BokehJL.Models.Plot().xaxis)
    plot = BokehJL.figure()

    @test !isempty(plot.xaxis)
    @test length(plot.xaxis) ≡ 1
    @test !any(isnothing(i.major_tick_line_color) for i ∈ plot.xaxis)

    @test isempty(plot.renderers)
    @test !any(i isa BokehJL.Models.Legend for i ∈ plot.center)
    BokehJL.line!(
        plot;
        source = Dict(
            "x" => [1, 2, 3],
            "y" => [3, 2, 1],
        ),
        legend_label = "label",
        dotrigger    = false,
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa BokehJL.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehJL.Models.Line
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]

    @nullevents plot.xaxis.major_tick_line_color = nothing
    @test all(isnothing(i.major_tick_line_color) for i ∈ plot.xaxis)
end

@testset "line stack" begin
    plt = BokehJL.linestack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.y ≡ "a"
    @test plt.renderers[2].glyph.y.fields.values == ["a", "b"]

    plt = BokehJL.linestack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.x ≡ "a"
    @test plt.renderers[2].glyph.x.fields.values == ["a", "b"]
end

@testset "bar stack" begin
    plt = BokehJL.barstack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.bottom ≡ 0.
    @test plt.renderers[1].glyph.top ≡ "a"
    @test plt.renderers[2].glyph.bottom ≡ "a"
    @test plt.renderers[2].glyph.top.fields.values == ["a", "b"]

    plt = BokehJL.barstack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.left ≡ 0.
    @test plt.renderers[1].glyph.right ≡ "a"
    @test plt.renderers[2].glyph.left ≡ "a"
    @test plt.renderers[2].glyph.right.fields.values == ["a", "b"]
end

@testset "area stack" begin
    plt = BokehJL.areastack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.y1 ≡ 0.
    @test plt.renderers[1].glyph.y2 ≡ "a"
    @test plt.renderers[2].glyph.y1 ≡ "a"
    @test plt.renderers[2].glyph.y2.fields.values == ["a", "b"]

    plt = BokehJL.areastack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.x1 ≡ 0.
    @test plt.renderers[1].glyph.x2 ≡ "a"
    @test plt.renderers[2].glyph.x1 ≡ "a"
    @test plt.renderers[2].glyph.x2.fields.values == ["a", "b"]
end
