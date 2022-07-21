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

        theme = BokehJL.Themes.Theme()
        BokehJL.Themes.read!(theme, path)

        @test :a ∈ keys(theme.items)
        @test :Int32 ∈ keys(theme.items[:a])
        @test :Float64 ∉ keys(theme.items[:a])

        @test :b ∈ keys(theme.items)
        @test :Int32 ∈ keys(theme.items[:b])
        @test :Float64 ∈ keys(theme.items[:b])

        @test BokehJL.Themes.theme(theme, Int32, :a) == Some(1.)
        @test BokehJL.Themes.theme(theme, Int32, :b) == Some(2.)
        @test BokehJL.Themes.theme(theme, Float64, :b) == Some(10.)
    end
end

@testset "create object" begin
    @eval abstract type _TestTheme1 <: BokehJL.iModel end

    @eval @BokehJL.wrap mutable struct _TestTheme2 <: _TestTheme1
        a::Float64 = -1.
        b::Float64 = -1.
        c::Float64 = -1.
    end

    doc   = BokehJL.Document()
    theme = doc.theme
    BokehJL.eventlist!() do
        BokehJL.curdoc!(doc) do
            @testset "no theme" for (i, j) ∈ (:a => -1 , :b => -1, :c => -1)
                @test getproperty(BokehJL.Themes.theme(theme, _TestTheme2), i) == j
                @test getproperty(_TestTheme2(), i) == j
            end

            BokehJL.Themes.setvalue!(theme, :_TestTheme1, :a, 10)
            BokehJL.Themes.setvalue!(theme, :_TestTheme1, :b, 10)
            BokehJL.Themes.setvalue!(theme, :_TestTheme2, :b, 20)
            @testset "with theme" for (i, j) ∈ (:a => 10 , :b => 20, :c => -1)
                @test getproperty(BokehJL.Themes.theme(theme, _TestTheme2), i) == j
                @test getproperty(_TestTheme2(), i) == j
            end
        end
    end
end

@testset "read bokeh themes" begin
    for name ∈ (:caliber, :contrast, :dark_minimal, :light_minimal, :night_sky)
        @test !isempty(BokehJL.Themes.Theme(name).items)
    end

    BokehJL.LinearAxis().major_label_text_font != "Calibri Light"
    BokehJL.Themes.setvalues!(:caliber) do
        BokehJL.LinearAxis().major_label_text_font == "Calibri Light"
    end
    BokehJL.LinearAxis().major_label_text_font != "Calibri Light"
end
