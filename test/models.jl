@testset "compare models" begin
    @test BokehServer.Model.compare((; a = 1), (; a = 1))
    @test !BokehServer.Model.compare((; a = 1), (; a = 1.))
    @test !BokehServer.Model.compare((; a = 1), (; b = 1))
    @test !BokehServer.Model.compare((; a = 1), (; a = 1, b = 1))
    @test !BokehServer.Model.compare((; a = 1), 2)

    @test BokehServer.Model.compare(Dict(:a => 1), Dict(:a => 1))
    @test !BokehServer.Model.compare(Dict(:a => 1), Dict(:a => 1.))
    @test !BokehServer.Model.compare(Dict(:a => 1), Dict(:b => 1))
    @test !BokehServer.Model.compare(Dict(:a => 1), Dict(:a => 1, :b => 1))
    @test !BokehServer.Model.compare(Dict(:a => 1), 2)

    @test BokehServer.Model.compare((1,), (1,))
    @test !BokehServer.Model.compare((1,), (1.,))
    @test !BokehServer.Model.compare((1,), (1, 1))
    @test !BokehServer.Model.compare((1,), 2)

    @test BokehServer.Model.compare([1,], [1,])
    @test !BokehServer.Model.compare([1], [1.,])
    @test !BokehServer.Model.compare([1], [1, 1])
    @test !BokehServer.Model.compare([1], 2)

    @test BokehServer.Model.compare(1, 1)
    @test !BokehServer.Model.compare(1, 1.)
    @test BokehServer.Model.compare(:a, :a)
    @test !BokehServer.Model.compare(:a, :ab)
    @test BokehServer.Model.compare("a", "a")
    @test !BokehServer.Model.compare("a", "ab")

    X1 = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a:: Int32
    end

    X2 = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        b:: Int32
    end

    @test BokehServer.Model.compare(X1(; id = 1), X2(; id = 1)) # comparison only uses ID!
    @test !BokehServer.Model.compare(X1(; id = 1), X1(; id = 2))
end

@testset "extract fields" begin
    out = BokehServer.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        a:: Int32
        # a line
        b:: Float32 = 1f0
    end))
    truth        = [
        (;
            index = 2, name = :a, type = Int32, default = Some(0),
            init  = Some(0), js = true,
            alias = false, readonly = false,
        ),
        (; 
            index = 4, name = :b, type = Float32, default = Some(1f0),
            init = Some(1f0), js = true,
            alias = false, readonly = false,
        ),
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ∈ (:default, :init)
                @test string(getfield(i, x)) == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end

    struct Dummy <: BokehServer.iModel
    end

    out = BokehServer.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        b:: Dummy
    end))
    truth = [
        (; 
            index = 2, name = :b, type = Dummy, default = "Some(:((Dummy)()))",
            init = "Some(:((Dummy)()))", js = true,
            alias = false, readonly = false,
        ),
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ∈ (:default, :init)
                @test replace(string(getfield(i, x)), "Main.anonymous."=> "") == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end

    out = BokehServer.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        b:: Vector{Dummy}       = zero
        c:: Dict{Int32, Dummy}  = nodefaults
        d:: Dict{Dummy, Int32}  = Dict(Dummy() => 1)
        e:: Set{Dummy}
    end))
    dflt(x)  = (; default = x, init = x, js = true, alias = false, readonly = false)
    truth = [
        (; index = 2, name = :b, type = Vector{Dummy}, dflt("Some(:((Vector{Dummy})()))")...),
        (; index = 4, name = :c, type = Dict{Int32, Dummy}, dflt(nothing)...),
        (; index = 6, name = :d, type = Dict{Dummy, Int32}, dflt(Some(:(Dict(Dummy()=>1))))...),
        (; index = 8, name = :e, type = Set{Dummy}, dflt("Some(:((Set{Dummy})()))")...)
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ∈ (:default, :init)
                @test replace(string(getfield(i, x)), "Main.anonymous."=> "") == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end
end

@testset "defaultvalue" begin
    ProtocolX = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::Int = 1
        b::Float64 = 2.
        c::Vector{String} = ["3"]
        d::String
    end
    @test BokehServer.Model.defaultvalue(ProtocolX, :a) ≡ Some(1)
    @test BokehServer.Model.defaultvalue(ProtocolX, :b) ≡ Some(2.)
    @test BokehServer.Model.defaultvalue(ProtocolX, :c) isa Some
    @test something(BokehServer.Model.defaultvalue(ProtocolX, :c)) == ["3"]
    @test BokehServer.Model.defaultvalue(ProtocolX, :d) ≡ nothing

    a = ProtocolX(; a = 10, d = "x")
    @test !BokehServer.Model.isdefaultvalue(a, :a)
    @test BokehServer.Model.isdefaultvalue(a, :b)
    @test BokehServer.Model.isdefaultvalue(a, :c)
    @test !BokehServer.Model.isdefaultvalue(a, :d)
end

@testset "bokeh structure" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test fieldnames(X) == (:id, :a, :b, :callbacks)
    @test propertynames(X()) == (:a, :b)
    @test X <: BokehServer.iModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0

    Z = @BokehServer.wrap  mutable struct gensym() <: BokehServer.iHasProps
        a::BokehServer.Model.Internal{Int32} = Int32(1)
        b::Float32 = 10f0
    end
    @test Z <: BokehServer.iHasProps
    @test !(Z <: BokehServer.iModel)
    @test fieldnames(Z) == (:id, :a, :b, :callbacks)
    @test propertynames(Z()) == (:a, :b)
    @test BokehServer.Model.bokehproperties(Z) == (:b,)
    @test fieldtype(Z, :a) ≡ Int32
end

@testset "bokeh children" begin
    # `evals` are needed to make sure X1 exists for Y1's declaration
    X1 = @eval @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::Int64 = 1
    end

    # `evals` are needed to make sure X1 exists for Y1's declaration
    Y1 = eval(:(@BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::Vector{$X1}      = [$X1(; a = 1), $X1(; a = 2)]
        b::Dict{Int64, $X1} = Dict(1 => $X1(; a = 3), 2 => $X1(; a = 4))
        c::Dict{Int64, Vector{$X1}} = Dict(1=> [$X1(; a = 5)])
        d::Set{$X1}         = Set([$X1(; a = 7), $X1(; a = 8)])
        e::$X1              = $X1(; a = 9)
    end))

    @test propertynames(Y1()) == (:a, :b, :c, :d, :e)
    @test BokehServer.Model.bokehproperties(Y1) == propertynames(Y1())

    y1  = Y1()
    all = BokehServer.bokehmodels(y1)
    @test BokehServer.bokehid(y1) ∈ keys(all)
    @test BokehServer.bokehid(y1.c[1][1]) ∈ keys(all)
    @test BokehServer.bokehid(y1.e) ∈ keys(all)
    @testset for i ∈ (y1.a, values(y1.b), y1.d), j ∈ i
        @test BokehServer.bokehid(j) ∈ keys(all)
    end

    Y2 = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.IntSpec = 1
    end

    y2 = Y2(; a = (field = "aaa", transform = X1(; id = 999)))
    @test collect(BokehServer.bokehchildren(y2)) == [y2.a.transform]
end

@testset "bokeh dataspec/container" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.IntSpec      = 1
        b::BokehServer.Model.DistanceSpec = 10f0
        c::Vector{Int64}            = Int64[1, 2]
    end
    @test fieldnames(X) == (:id, :a, :b, :c, :callbacks)
    @test propertynames(X()) == (:a, :b, :c)
    @test X <: BokehServer.iModel
    @test X().a ≡ 1
    @test X().b ≡ 10.0
    @test fieldtype(X, :c) ≡ Vector{Int64}
    @test X().c isa BokehServer.Model.Container{Vector{Int64}}
    @test X().c.values == [1, 2]

    x = X()
    push!(x.c, 10; dotrigger = false)
    @test x.c.values == Int64[1, 2, 10]
    empty!(x.c; dotrigger = false)
    @test isempty(x.c.values)
end

@testset "bokeh restricteddict" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        b::Dict{BokehServer.Model.RestrictedKey{(:a,)}, Int}
    end
    @test fieldtype(X, :b) ≡ Dict{Symbol, Int}
    @test X().b isa BokehServer.Model.Container{Dict{BokehServer.Model.RestrictedKey{(:a,)}, Int64}}

    x = X()
    @nullevents push!(x.b, :mmm => 1)
    @test x.b[:mmm] ≡ 1

    @test_throws KeyError x.b[:a] = 2
end

@testset "bokeh tuple attribute" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.Tuple{BokehServer.Model.IntSpec, Float64}  = (1, 2.0)
    end
    @test X().a ≡ (1, 2.0)
    @test fieldtype(X, :a) ≡ Tuple{BokehServer.Model.IntSpec, Float64}
    x = X(; a = ("toto", 4))
    @test x.a == ("toto", 4.0)
    @nullevents x.a = (Dict("value" => 10), -1.0)
    @test x.a == (10, -1.0)
end

𝐸T = BokehServer.Model.EnumType{(:a, :b, :c)}

@testset "bokeh either attribute" begin
    @test collect(Type, BokehServer.Model.UnionIterator(Union{Symbol, String})) == [Symbol, String]
    @test collect(Type, BokehServer.Model.UnionIterator(Union{Symbol, String, Float32})) == [Float32, Symbol, String]

    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.Union{𝐸T, Float64} = "a"
    end
    @test fieldtype(X, :a) ≡ Union{𝐸T, Float64}
    @test X().a == :a
    x = X(; a = 4)
    @test x.a ≡ 4.0
    @nullevents x.a = :c
    @test x.a == :c
    @test_throws ErrorException X(; a = :mmm)
end

@testset "bokeh namedstruct attribute" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::@NamedTuple{x :: 𝐸T, y:: Float64}  = (; x = :a, y = 1.0)
    end
    @test fieldtype(X, :a) ≡ @NamedTuple{x::𝐸T, y::Float64}
    @test X().a.x == :a
    @test X().a.y == 1.0
    x = X(; a = (; x  = :b, y = 4.0))
    @test x.a.x == :b
    @test x.a.y == 4.0
    @nullevents x.a = (; y= 10., x = :c)
    @test x.a.x == :c
    @test x.a.y == 10.0
    @test_throws ErrorException X(; a = (; x = :mmm, y = 10.))
end

@testset "bokeh color" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.Color =  :gray
        b::BokehServer.Model.ColorSpec =  "gray"
    end
    @test X().a.r ≡ X().a.g ≡ X().a.b ≡ 0x80
    @test X().a.a ≡ 0xff

    @test !ismissing(BokehServer.Model.color("rgb(1, 2, 3)"))
    @test !ismissing(BokehServer.Model.color("#010101"))
    x = X(; a = "rgb(1,2,3)")
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)

    x = X(; a= (1,2,3))
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)

    @test x.b == BokehServer.Model.colorhex(:gray)
    @test X(; b = "aaa").b == "aaa"
end

@testset "bokeh marker" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        a::BokehServer.Model.MarkerSpec = "x"
    end
    @test X().a == :x
    @test X(;a = "fff").a == "fff"
end

@testset "bokeh complex field" begin
    X = @BokehServer.wrap mutable struct gensym() <: BokehServer.iModel
        rows::Union{
            BokehServer.enum"max,fit,auto,min",
            Int64,
            Dict{
                Union{Int64, String},
                Union{
                    BokehServer.Model.enum"max,fit,auto,min",
                    Int64,
                    @NamedTuple{
                        policy::BokehServer.Model.enum"auto,min",
                        align::BokehServer.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::BokehServer.Model.enum"fixed",
                        height::Int64,
                        align::BokehServer.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::BokehServer.Model.enum"max,fit",
                        flex::Float64,
                        align::BokehServer.Model.enum"start,end,auto,center"
                    }
                }
            }
        }
    end
    @test X(; rows = :auto).rows == :auto
    @test X(; rows = 10).rows ≡ 10

    x = X(; rows = Dict(1=>10))
    @test x.rows isa BokehServer.Model.Container{<:Dict}
    @test x.rows[1] ≡ 10

    @nullevents x.rows[1] = :max
    @test x.rows[1] == :max

    @nullevents x.rows[1] = (; policy= :auto, align = :start)
    @test x.rows[1].policy == :auto
    @test x.rows[1].align == :start

    @test_throws ErrorException X(; a = (; policy = :mmm,  align = :start))
end

@testset "columndatasource" begin
    cds = BokehServer.Source("x" => 1:5; y = 1:5, selection_policy = BokehServer.IntersectRenderers())
    @test "x" ∈ keys(cds.data)
    @test "y" ∈ keys(cds.data)
    @test cds.selection_policy isa BokehServer.IntersectRenderers
end
