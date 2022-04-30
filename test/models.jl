@testset "model creation" begin
    @testset "extract fields" begin
        out = Bokeh.Models._model_fields(@__MODULE__, :(mutable struct X <: iModel
            a:: Int32
            # a line
            b:: Float32 = 1f0
        end))
        truth = [
            (; index = 2, name = :a, type = :Int32, default = nothing, js = true, child = false, children = false),
            (; index = 4, name = :b, type = :Float32, default = Some(1f0), js = true, child = false, children = false),
        ]
        @testset for (i, j) ∈ zip(out, truth)
            @test i == j
        end

        struct Dummy <: Bokeh.iModel
        end

        out = Bokeh.Models._model_fields(@__MODULE__, :(mutable struct X <: iModel
            b:: Dummy
        end))
        truth = [
            (; index = 2, name = :b, type = :Dummy, default = nothing, js = true, child = true, children = false),
        ]
        @testset for (i, j) ∈ zip(out, truth)
            @test i == j
        end

        out = Bokeh.Models._model_fields(@__MODULE__, :(mutable struct X <: iModel
            b:: Vector{Dummy}
            c:: Dict{Int32, Dummy}
            d:: Dict{Dummy, Int32}
            e:: Set{Dummy}
        end))
        dflt  = (; default = nothing, js = true, child = false, children = true)
        truth = [
            (; index = 2, name = :b, type = :(Vector{Dummy}), dflt...),
            (; index = 4, name = :c, type = :(Dict{Int32, Dummy}), dflt...),
            (; index = 6, name = :d, type = :(Dict{Dummy, Int32}), dflt...),
            (; index = 8, name = :e, type = :(Set{Dummy}), dflt...)
        ]
        @testset for (i, j) ∈ zip(out, truth)
            @test i == j
        end
    end
end
