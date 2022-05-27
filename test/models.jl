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

@testset "bokeh structure" begin
    @Bokeh.model mutable struct X <: Bokeh.iModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test fieldnames(X) == (:id, :a, :b, :callbacks)
    @test propertynames(X()) == (:a, :b)
    @test X <: Bokeh.iModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0

    @Bokeh.model  mutable struct Z <: Bokeh.iHasProps
        a::Bokeh.Models.Internal{Int32} = Int32(1)
        b::Float32 = 10f0
    end
    @test Z <: Bokeh.iHasProps
    @test !(Z <: Bokeh.iModel)
    @test fieldnames(Z) == (:id, :a, :b)
    @test propertynames(Z()) == (:a, :b)
    @test Bokeh.Models.bokehproperties(Z) == (:b,)
    @test fieldtype(Z, :a) ≡ Int32
end

@testset "bokeh dataspec/container" begin
    @Bokeh.model mutable struct X <: Bokeh.iModel
        a::Bokeh.Models.Spec{Int32}  = Int32(1)
        b::Bokeh.Models.DistanceSpec = 10f0
        c::Vector{Int64}             = Int64[1, 2]
    end
    @test fieldnames(X) == (:id, :a, :b, :c :callbacks)
    @test propertynames(X()) == (:a, :b, :c)
    @test X <: Bokeh.iModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0
    @test X().c isa Bokeh.Models.Container{Vector{Int64}}
    @test X().c.values == [1, 2]
    @test fieldtype(X, :c) ≡ Vector{Int64}

    x = X()
    push!(x.c, 10)
    @test x.c.values == Int64[1, 2, 10]
    empty!(x.c)
    @test isempty(x.c.values)
end

@testset "bokeh color" begin
    @Bokeh.model mutable struct X <: Bokeh.iModel
        a::Bokeh.Models.Color =  :gray
    end
    @test X().a.r == X().a.g == X().a.b == X().a.a == 0xff

    x = X(; a = "rgb(1,2,3)")
    @test x.r ≡ UInt8(1)
    @test x.g ≡ UInt8(2)
    @test x.b ≡ UInt8(3)

    x = X(; a= (1,2,3))
    @test x.r ≡ UInt8(1)
    @test x.g ≡ UInt8(2)
    @test x.b ≡ UInt8(3)
end

@testset "bokeh marker" begin
    @Bokeh.model mutable struct X <: Bokeh.iModel
        a::Bokeh.Models.MarkerSpec = "x"
    end
    @test X().a == (; value = :x)
    @test X(;a = "fff").a == (; field = "fff")
end

@testset "bokeh children" begin
    # `evals` are needed to make sure X1 exists for Y1's declaration
    @eval @Bokeh.model mutable struct X1 <: Bokeh.iModel
        a::Int64 = 1
    end

    # `evals` are needed to make sure X1 exists for Y1's declaration
    @eval @Bokeh.model mutable struct Y1 <: Bokeh.iModel
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
