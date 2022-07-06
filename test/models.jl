@testset "compare models" begin
    @test BokehJL.Model.compare((; a = 1), (; a = 1))
    @test !BokehJL.Model.compare((; a = 1), (; a = 1.))
    @test !BokehJL.Model.compare((; a = 1), (; b = 1))
    @test !BokehJL.Model.compare((; a = 1), (; a = 1, b = 1))
    @test !BokehJL.Model.compare((; a = 1), 2)

    @test BokehJL.Model.compare(Dict(:a => 1), Dict(:a => 1))
    @test !BokehJL.Model.compare(Dict(:a => 1), Dict(:a => 1.))
    @test !BokehJL.Model.compare(Dict(:a => 1), Dict(:b => 1))
    @test !BokehJL.Model.compare(Dict(:a => 1), Dict(:a => 1, :b => 1))
    @test !BokehJL.Model.compare(Dict(:a => 1), 2)

    @test BokehJL.Model.compare((1,), (1,))
    @test !BokehJL.Model.compare((1,), (1.,))
    @test !BokehJL.Model.compare((1,), (1, 1))
    @test !BokehJL.Model.compare((1,), 2)

    @test BokehJL.Model.compare([1,], [1,])
    @test !BokehJL.Model.compare([1], [1.,])
    @test !BokehJL.Model.compare([1], [1, 1])
    @test !BokehJL.Model.compare([1], 2)

    @test BokehJL.Model.compare(1, 1)
    @test !BokehJL.Model.compare(1, 1.)
    @test BokehJL.Model.compare(:a, :a)
    @test !BokehJL.Model.compare(:a, :ab)
    @test BokehJL.Model.compare("a", "a")
    @test !BokehJL.Model.compare("a", "ab")

    X1 = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a:: Int32
    end

    X2 = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        b:: Int32
    end

    @test BokehJL.Model.compare(X1(; id = 1), X2(; id = 1)) # comparison only uses ID!
    @test !BokehJL.Model.compare(X1(; id = 1), X1(; id = 2))
end

@testset "extract fields" begin
    out = BokehJL.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        a:: Int32
        # a line
        b:: Float32 = 1f0
    end))
    truth        = [
        (;
            index = 2, name = :a, type = Int32, default = Some(:(zero(Int32))),
            init  = Some(:(zero(Int32))), js = true,
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

    struct Dummy <: BokehJL.iModel
    end

    out = BokehJL.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
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

    out = BokehJL.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
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
    ProtocolX = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::Int = 1
        b::Float64 = 2.
        c::Vector{String} = ["3"]
        d::String
    end
    @test BokehJL.Model.defaultvalue(ProtocolX, :a) ≡ Some(1)
    @test BokehJL.Model.defaultvalue(ProtocolX, :b) ≡ Some(2.)
    @test BokehJL.Model.defaultvalue(ProtocolX, :c) isa Some
    @test something(BokehJL.Model.defaultvalue(ProtocolX, :c)) == ["3"]
    @test BokehJL.Model.defaultvalue(ProtocolX, :d) ≡ nothing

    a = ProtocolX(; a = 10, d = "x")
    @test !BokehJL.Model.isdefaultvalue(a, :a)
    @test BokehJL.Model.isdefaultvalue(a, :b)
    @test BokehJL.Model.isdefaultvalue(a, :c)
    @test !BokehJL.Model.isdefaultvalue(a, :d)
end

@testset "bokeh structure" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test fieldnames(X) == (:id, :a, :b, :callbacks)
    @test propertynames(X()) == (:a, :b)
    @test X <: BokehJL.iModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0

    Z = @BokehJL.wrap  mutable struct gensym() <: BokehJL.iHasProps
        a::BokehJL.Model.Internal{Int32} = Int32(1)
        b::Float32 = 10f0
    end
    @test Z <: BokehJL.iHasProps
    @test !(Z <: BokehJL.iModel)
    @test fieldnames(Z) == (:id, :a, :b, :callbacks)
    @test propertynames(Z()) == (:a, :b)
    @test BokehJL.Model.bokehproperties(Z) == (:b,)
    @test fieldtype(Z, :a) ≡ Int32
end

@testset "bokeh children" begin
    # `evals` are needed to make sure X1 exists for Y1's declaration
    X1 = @eval @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::Int64 = 1
    end

    # `evals` are needed to make sure X1 exists for Y1's declaration
    Y1 = eval(:(@BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::Vector{$X1}      = [$X1(; a = 1), $X1(; a = 2)]
        b::Dict{Int64, $X1} = Dict(1 => $X1(; a = 3), 2 => $X1(; a = 4))
        c::Dict{$X1, Int64} = Dict($X1(; a = 5) => 1, $X1(; a = 6) => 2)
        d::Set{$X1}         = Set([$X1(; a = 7), $X1(; a = 8)])
        e::$X1              = $X1(; a = 9)
    end))

    @test propertynames(Y1()) == (:a, :b, :c, :d, :e)
    @test BokehJL.Model.bokehproperties(Y1) == propertynames(Y1())

    y1  = Y1()
    all = BokehJL.allmodels(y1)
    @test BokehJL.bokehid(y1) ∈ keys(all)
    @test BokehJL.bokehid(y1.e) ∈ keys(all)
    @testset for i ∈ (y1.a, values(y1.b), keys(y1.c), y1.d), j ∈ i
        @test BokehJL.bokehid(j) ∈ keys(all)
    end
end

@testset "bokeh dataspec/container" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::BokehJL.Model.IntSpec      = 1
        b::BokehJL.Model.DistanceSpec = 10f0
        c::Vector{Int64}            = Int64[1, 2]
    end
    @test fieldnames(X) == (:id, :a, :b, :c, :callbacks)
    @test propertynames(X()) == (:a, :b, :c)
    @test X <: BokehJL.iModel
    @test X().a ≡ 1
    @test X().b ≡ 10.0
    @test fieldtype(X, :c) ≡ Vector{Int64}
    @test X().c isa BokehJL.Model.Container{Vector{Int64}}
    @test X().c.values == [1, 2]

    x = X()
    push!(x.c, 10; dotrigger = false)
    @test x.c.values == Int64[1, 2, 10]
    empty!(x.c; dotrigger = false)
    @test isempty(x.c.values)
end

@testset "bokeh restricteddict" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        b::Dict{BokehJL.Model.RestrictedKey{(:a,)}, Int}
    end
    @test fieldtype(X, :b) ≡ Dict{Symbol, Int}
    @test X().b isa BokehJL.Model.Container{Dict{BokehJL.Model.RestrictedKey{(:a,)}, Int64}}

    x = X()
    @nullevents push!(x.b, :mmm => 1)
    @test x.b[:mmm] ≡ 1

    @test_throws KeyError x.b[:a] = 2
end

@testset "bokeh tuple attribute" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::BokehJL.Model.Tuple{BokehJL.Model.IntSpec, Float64}  = (1, 2.0)
    end
    @test X().a ≡ (1, 2.0)
    @test fieldtype(X, :a) ≡ Tuple{BokehJL.Model.IntSpec, Float64}
    x = X(; a = ("toto", 4))
    @test x.a == ("toto", 4.0)
    @nullevents x.a = (Dict("value" => 10), -1.0)
    @test x.a == (10, -1.0)
end

𝐸T = BokehJL.Model.EnumType{(:a, :b, :c)}

@testset "bokeh either attribute" begin
    @test collect(Type, BokehJL.Model.UnionIterator(Union{Symbol, String})) == [Symbol, String]
    @test collect(Type, BokehJL.Model.UnionIterator(Union{Symbol, String, Float32})) == [Float32, Symbol, String]

    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::BokehJL.Model.Union{𝐸T, Float64} = "a"
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
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
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
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::BokehJL.Model.Color =  :gray
        b::BokehJL.Model.ColorSpec =  "gray"
    end
    @test X().a.r ≡ X().a.g ≡ X().a.b ≡ 0x80
    @test X().a.a ≡ 0xff

    @test !ismissing(BokehJL.Model.color("rgb(1, 2, 3)"))
    @test !ismissing(BokehJL.Model.color("#010101"))
    x = X(; a = "rgb(1,2,3)")
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)

    x = X(; a= (1,2,3))
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)

    @test x.b == BokehJL.Model.colorhex(:gray)
    @test X(; b = "aaa").b == "aaa"
end

@testset "bokeh marker" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        a::BokehJL.Model.MarkerSpec = "x"
    end
    @test X().a == :x
    @test X(;a = "fff").a == "fff"
end

@testset "bokeh complex field" begin
    X = @BokehJL.wrap mutable struct gensym() <: BokehJL.iModel
        rows::Union{
            BokehJL.enum"max,fit,auto,min",
            Int64,
            Dict{
                Union{Int64, String},
                Union{
                    BokehJL.Model.enum"max,fit,auto,min",
                    Int64,
                    @NamedTuple{
                        policy::BokehJL.Model.enum"auto,min",
                        align::BokehJL.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::BokehJL.Model.enum"fixed",
                        height::Int64,
                        align::BokehJL.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::BokehJL.Model.enum"max,fit",
                        flex::Float64,
                        align::BokehJL.Model.enum"start,end,auto,center"
                    }
                }
            }
        }
    end
    @test X(; rows = :auto).rows == :auto
    @test X(; rows = 10).rows ≡ 10

    x = X(; rows = Dict(1=>10))
    @test x.rows isa BokehJL.Model.Container{<:Dict}
    @test x.rows[1] ≡ 10

    @nullevents x.rows[1] = :max
    @test x.rows[1] == :max

    @nullevents x.rows[1] = (; policy= :auto, align = :start)
    @test x.rows[1].policy == :auto
    @test x.rows[1].align == :start

    @test_throws ErrorException X(; a = (; policy = :mmm,  align = :start))
end
