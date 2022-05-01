@testset "read file" begin
    mktempdir() do path
        path = joinpath(path, "theme.json")
        open(path, "w") do io
            println(io, """{
                "Int32" : {
                    "a" : 1.,
                    "b" : 2.
                },
                "Float64" : {
                    "b" : 10.
                }
            }""")
        end

        theme = Bokeh.Themes.Theme()
        Bokeh.Themes.read!(theme, path)

        @test :a ∈ keys(theme.items)
        @test :Int32 ∈ keys(theme.items[:a])
        @test :Float64 ∉ keys(theme.items[:a])

        @test :b ∈ keys(theme.items)
        @test :Int32 ∈ keys(theme.items[:b])
        @test :Float64 ∈ keys(theme.items[:b])

        @test Bokeh.Themes.getvalue(theme, Int32, :a)() == 1.
        @test Bokeh.Themes.getvalue(theme, Int32, :b)() == 2.
        @test Bokeh.Themes.getvalue(theme, Float64, :b)() == 10.
    end
end

@testset "create object" begin
    @eval abstract type _TestTheme1 <: Bokeh.iModel end

    @eval @Bokeh.model mutable struct _TestTheme2 <: _TestTheme1
        a::Float64 = -1.
        b::Float64 = -1.
        c::Float64 = -1.
    end

    theme = Bokeh.Themes.Theme()
    @testset "no theme" for (i, j) ∈ (:a => -1 , :b => -1, :c => -1)
        @test getproperty(Bokeh.Themes.theme(theme,   Data_TestTheme2), i) == j
    end

    Bokeh.Themes.setvalue!(theme, :_TestTheme1, :a, ()->10)
    Bokeh.Themes.setvalue!(theme, :_TestTheme1, :b, ()->10)
    Bokeh.Themes.setvalue!(theme, :_TestTheme2, :b, ()->20)
    @testset "no theme" for (i, j) ∈ (:a => 10 , :b => 20, :c => -1)
        @test getproperty(Bokeh.Themes.theme(theme, _TestTheme2), i) == j
    end
end
