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

    @testset "callback structure" begin
        eval(Bokeh.Models._model_cbcls(:__A, [
            (; js = true, name = :a), (; js = false, name = :b)]
        ))
        @test fieldnames(Cb__A) == (:a,)
        @test fieldtypes(Cb__A) == (Vector{Function},)
        @test Cb__A() isa Cb__A
    end

    @testset "data source structure" begin
        eval(Bokeh.Models._model_srccls(
            :__A,
            [(; js = true, name = :a), (; js = false, name = :b)],
            true
        ))
        @test fieldnames(Src__A) == (:source, :a,)
        @test fieldtypes(Src__A) == (Union{Bokeh.iDataSource, Nothing}, Union{Symbol, Nothing},)
        @test Src__A() isa Src__A
        @test isnothing(Bokeh.Models._model_srccls(
            :__A,
            [(; js = true, name = :a), (; js = false, name = :b)],
            false
        ))
    end

    @testset "bokeh structure" begin
        @Bokeh.model source = true struct X
            a::Int32   = Int32(1)
            b::Float32 = 10f0
        end
        @test fieldnames(X) == (:id, :values, :callbacks, :source)
        @test propertynames(X()) == (:a, :b, :data_source)
        @test X <: Bokeh.iSourcedModel

        @Bokeh.model struct Y
            a::Int32   = Int32(1)
            b::Float32 = 10f0
        end
        @test Y <: Bokeh.iModel
        @test !(Y <: Bokeh.iSourcedModel)
        @test fieldnames(Y) == (:id, :values, :callbacks)
        @test propertynames(Y()) == (:a, :b)
        @test Bokeh.Models.bokehproperties(Y) == (:a, :b)

        @Bokeh.model parent = iHasProps internal = [a] struct Z
            a::Int32   = Int32(1)
            b::Float32 = 10f0
        end
        @test Z <: Bokeh.iHasProps
        @test !(Z <: Bokeh.iModel)
        @test fieldnames(Z) == (:id, :values, :callbacks)
        @test propertynames(Z()) == (:a, :b)
        @test Bokeh.Models.bokehproperties(Z) == (:b,)
    end
end
