@testset "create figure" begin
    plot = BokehServer.Plotting.figure()
    @test plot isa BokehServer.Models.Plot
    @test nameof.(typeof.(plot.toolbar.tools)) == [
        :PanTool, :WheelZoomTool, :BoxZoomTool,:SaveTool,:ResetTool,:HelpTool
    ]

    plot = BokehServer.Plotting.figure(;
        x_range      = 1:100,
        x_axis_type  = :log,
        x_axis_label = "x axis"
    )
    @test plot.x_range.start ≡ 1.
    @test plot.x_range.finish ≡ 100.
    @test plot.below[end] isa BokehServer.Models.LogAxis
    @test plot.below[end].axis_label == "x axis"

    items = BokehServer.Plotting.getaxis(plot, :x)
    @test items.range ≡ plot.x_range
    @test items.scale ≡ plot.x_scale
    @test items.axes  == [plot.below[end]]
    @test length(items.grids) == 1

    BokehServer.Plotting.popaxis!(plot, items; dotrigger = false)

    items = BokehServer.Plotting.getaxis(plot, :x)
    @test length(items.axes) == 0
    @test length(items.grids) == 0
end

@testset "create layout" begin
    plt = BokehServer.Models.Plot()
    @assert plt isa BokehServer.Models.iLayoutDOM
    obj = BokehServer.Plotting.layout([plt, plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (1,0,1,1)]

    obj = BokehServer.Plotting.layout([plt, plt]'; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1)]

    obj = BokehServer.Plotting.layout([[plt, plt]', plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 2)]

    obj = BokehServer.Plotting.layout([plt plt; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehServer.Plotting.layout([nothing plt; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,1,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehServer.Plotting.layout([plt plt; plt nothing]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 0, 1, 1)]

    obj = BokehServer.Plotting.layout([plt nothing; plt plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (1, 0, 1, 1), (1, 1, 1, 1)]

    obj = BokehServer.Plotting.layout([plt plt; nothing plt]; toolbar_location = nothing, dotrigger = false)
    @test [i[2:end] for i ∈ obj.children] == [(0,0,1,1), (0,1,1,1), (1, 1, 1, 1)]

    obj = BokehServer.Plotting.layout([plt plt]; toolbar_location = :above, dotrigger = false)
    @test obj isa BokehServer.Models.Column
    @test obj.children[2] isa BokehServer.Models.GridBox

    obj = BokehServer.Plotting.layout([plt plt]; toolbar_location = :right, dotrigger = false)
    @test obj isa BokehServer.Models.Row
    @test obj.children[1] isa BokehServer.Models.GridBox
end

@testset "create glyph" begin
    plot = BokehServer.Plotting.figure()
    @test isempty(plot.renderers)
    @test !any(i isa BokehServer.Models.Legend for i ∈ plot.center)
    BokehServer.Plotting.scatter!(
        plot;
        x            = [1, 2, 3],
        y            = [3, 2, 1],
        legend_label = "label",
        marker       = :x,
        dotrigger    = false,
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa BokehServer.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehServer.Models.Scatter
    @test plot.renderers[1].glyph.marker == :x
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]

    mdls = BokehServer.Model.bokehmodels(plot)
    @test plot.renderers[1].glyph.id ∈ keys(mdls)
    @test plot.below[end].id ∈ keys(mdls)
    @test plot.left[end].id ∈ keys(mdls)
end

@testset "create rect" begin
    plot = BokehServer.Plotting.figure()
    @test isempty(plot.renderers)
    @test !any(i isa BokehServer.Models.Legend for i ∈ plot.center)
    BokehServer.rect!(
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
    @test plot.renderers[1] isa BokehServer.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehServer.Models.Rect
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]
    @test plot.renderers[1].data_source.data["color"] == ["#0000FF", "#FF0000", "#008000"]
    @test plot.renderers[1].glyph.fill_color == "color"
    @test plot.renderers[1].glyph.hatch_color == "color"
    @test plot.renderers[1].hover_glyph.hatch_color == "#00FF00"
    @test plot.renderers[1].hover_glyph.fill_color == "#00FF00"
end

@testset "create line" begin
    @test isempty(BokehServer.Models.Plot().xaxis)
    plot = BokehServer.figure()

    @test !isempty(plot.xaxis)
    @test length(plot.xaxis) ≡ 1
    @test !any(isnothing(i.major_tick_line_color) for i ∈ plot.xaxis)

    @test isempty(plot.renderers)
    @test !any(i isa BokehServer.Models.Legend for i ∈ plot.center)
    BokehServer.line!(
        plot;
        source = Dict(
            "x" => [1, 2, 3],
            "y" => [3, 2, 1],
        ),
        legend_label = "label",
        dotrigger    = false,
    )

    @test length(plot.renderers) ≡ 1
    @test plot.renderers[1] isa BokehServer.Models.GlyphRenderer
    @test plot.renderers[1].glyph isa BokehServer.Models.Line
    @test plot.renderers[1].data_source.data["x"] == [1, 2, 3]
    @test plot.renderers[1].data_source.data["y"] == [3, 2, 1]

    @nullevents plot.xaxis.major_tick_line_color = nothing
    @test all(isnothing(i.major_tick_line_color) for i ∈ plot.xaxis)
end

@testset "line stack" begin
    plt = BokehServer.linestack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.y ≡ "a"
    @test plt.renderers[2].glyph.y.fields.values == ["a", "b"]

    plt = BokehServer.linestack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.x ≡ "a"
    @test plt.renderers[2].glyph.x.fields.values == ["a", "b"]
end

@testset "bar stack" begin
    plt = BokehServer.barstack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.bottom ≡ 0.
    @test plt.renderers[1].glyph.top ≡ "a"
    @test plt.renderers[2].glyph.bottom ≡ "a"
    @test plt.renderers[2].glyph.top.fields.values == ["a", "b"]

    plt = BokehServer.barstack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.left ≡ 0.
    @test plt.renderers[1].glyph.right ≡ "a"
    @test plt.renderers[2].glyph.left ≡ "a"
    @test plt.renderers[2].glyph.right.fields.values == ["a", "b"]
end

@testset "area stack" begin
    plt = BokehServer.areastack(; y = ["a", "b"], x = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.y1 ≡ 0.
    @test plt.renderers[1].glyph.y2 ≡ "a"
    @test plt.renderers[2].glyph.y1 ≡ "a"
    @test plt.renderers[2].glyph.y2.fields.values == ["a", "b"]

    plt = BokehServer.areastack(; x = ["a", "b"], y = "c", source = Dict("a"=> [1.], "b" => [1.] , "c"=>[1.]))
    @test length(plt.renderers) ≡ 2
    @test plt.renderers[1].glyph.x1 ≡ 0.
    @test plt.renderers[1].glyph.x2 ≡ "a"
    @test plt.renderers[2].glyph.x1 ≡ "a"
    @test plt.renderers[2].glyph.x2.fields.values == ["a", "b"]
end

@testset "boxplot" begin
    labels = [j == 1 ? "x" : "y" for j = 1:2 for _ = 1:(j*10)]
    vals   = [(randn(Float64, 10) .+ 10.)..., (randn(Float64, 20) .- 10.)...]
    x = BokehServer.Plotting.boxplotitems(labels, vals)
    @test x[1].key == "y"
    @test x[1].quantiles[2]  < 0.
    @test x[2].key == "x"
    @test x[2].quantiles[2]  > 0.

    plot = BokehServer.boxplot(labels, vals)
    @test plot.x_range isa BokehServer.Models.FactorRange
    @test length(plot.renderers) == 4
end

struct DummyStaticRoute <: BokehServer.Server.iStaticRoute end
BokehServer.Server.makeid(::DummyStaticRoute) = "a"

@testset "standalone" begin
    BokehServer.Model.ID.ids[:] .= 1
    out = BokehServer.html(; title = "my favorite plot", browser = false, app = DummyStaticRoute()) do
        BokehServer.line(; y = [1,2,3])
    end
    @test out isa HTML
    truth = read(joinpath(@__DIR__, "standalone.html"), String)
    @testset for (i,j) ∈ zip(eachline(IOBuffer(truth)), eachline(IOBuffer(out.content)))
        @test i == j
    end
end
