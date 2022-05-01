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
    @Bokeh.model mutable struct X <: Bokeh.iSourcedModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test fieldnames(X) == (:id, :original, :callbacks, :source)
    @test propertynames(X()) == (:a, :b, :data_source)
    @test X <: Bokeh.iSourcedModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0

    @Bokeh.model mutable struct Y <: Bokeh.iModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test Y <: Bokeh.iModel
    @test !(Y <: Bokeh.iSourcedModel)
    @test fieldnames(Y) == (:id, :original, :callbacks)
    @test propertynames(Y()) == (:a, :b)
    @test Bokeh.Models.bokehproperties(Y) == (:a, :b)
    @test Y().a ≡ one(Int32)
    @test Y().b ≡ 10f0

    @Bokeh.model internal = [a] mutable struct Z <: Bokeh.iHasProps
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test Z <: Bokeh.iHasProps
    @test !(Z <: Bokeh.iModel)
    @test fieldnames(Z) == (:id, :original, :callbacks)
    @test propertynames(Z()) == (:a, :b)
    @test Bokeh.Models.bokehproperties(Z) == (:b,)
end

@testset "bokeh children" begin
    # `evals` are needed to make sure X1 exists for Y1's declaration
    @eval @Bokeh.model mutable struct X1 <: Bokeh.iModel
        a::Int64 = 1
    end

    # `evals` are needed to make sure X1 exists for Y1's declaration
    @eval @Bokeh.model source = false mutable struct Y1 <: Bokeh.iModel
        a::Vector{X1}      = [X1(; a = 1), X1(; a = 2)]
        b::Dict{Int64, X1} = Dict(1 => X1(; a = 3), 2 => X1(; a = 4))
        c::Dict{X1, Int64} = Dict(X1(; a = 5) => 1, X1(; a = 6) => 2)
        d::Set{X1}         = Set([X1(; a = 7), X1(; a = 8)])
        e::X1              = X1(; a = 9)
    end

    @test propertynames(Y1()) == (:a, :b, :c, :d, :e)
    @test Bokeh.Models.bokehproperties(Y1) == propertynames(Y1())
    @test Bokeh.Models.bokehproperties(Y1; select = :child) == (:e,)
    @test Bokeh.Models.bokehproperties(Y1; select = :children) == (:a, :b, :c, :d)

    y1  = Y1()
    all = Bokeh.allmodels(y1)
    @test Bokeh.bokehid(y1) ∈ keys(all)
    @test Bokeh.bokehid(y1.e) ∈ keys(all)
    @testset for i ∈ (y1.a, values(y1.b), keys(y1.c), y1.d), j ∈ i
        @test Bokeh.bokehid(j) ∈ keys(all)
    end
end
