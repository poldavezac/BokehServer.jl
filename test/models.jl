@testset "extract fields" begin
    out = Bokeh.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        a:: Int32
        # a line
        b:: Float32 = 1f0
    end))
    truth        = [
        (;
            index = 2, name = :a, type = Int32, default = Some(:(zero(Int32))), js = true,
            alias = false, readonly = false, child = false, children = false
        ),
        (; 
            index = 4, name = :b, type = Float32, default = Some(1f0), js = true,
            alias = false, readonly = false, child = false, children = false
        ),
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ≡ :default
                @test string(getfield(i, x)) == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end

    struct Dummy <: Bokeh.iModel
    end

    out = Bokeh.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        b:: Dummy
    end))
    truth = [
        (; 
            index = 2, name = :b, type = Dummy, default = "Some(:((Dummy)()))", js = true,
            alias = false, readonly = false, child = true, children = false
        ),
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ≡ :default
                @test replace(string(getfield(i, x)), "Main.anonymous."=> "") == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end

    out = Bokeh.Model._👻fields(@__MODULE__, :(mutable struct X <: iModel
        b:: Vector{Dummy}       = zero
        c:: Dict{Int32, Dummy}  = nodefaults
        d:: Dict{Dummy, Int32}  = Dict(Dummy() => 1)
        e:: Set{Dummy}
    end))
    dflt(x)  = (; default = x, js = true, alias = false, readonly = false, child = false, children = true)
    truth = [
        (; index = 2, name = :b, type = Vector{Dummy}, dflt("Some(:((Vector{Dummy})()))")...),
        (; index = 4, name = :c, type = Dict{Int32, Dummy}, dflt(nothing)...),
        (; index = 6, name = :d, type = Dict{Dummy, Int32}, dflt(Some(:(Dict(Dummy()=>1))))...),
        (; index = 8, name = :e, type = Set{Dummy}, dflt("Some(:((Set{Dummy})()))")...)
    ]
    @testset for (i, j) ∈ zip(out, truth)
        for x ∈ propertynames(i)
            if x ≡ :default
                @test replace(string(getfield(i, x)), "Main.anonymous."=> "") == string(getfield(j, x))
            else
                @test getfield(i, x) == getfield(j, x)
            end
        end
    end
end

@testset "defaultvalue" begin
    ProtocolX = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Int = 1
        b::Float64 = 2.
        c::Vector{String} = ["3"]
        d::String
    end
    @test Bokeh.Model.defaultvalue(ProtocolX, :a) ≡ Some(1)
    @test Bokeh.Model.defaultvalue(ProtocolX, :b) ≡ Some(2.)
    @test Bokeh.Model.defaultvalue(ProtocolX, :c) isa Some
    @test something(Bokeh.Model.defaultvalue(ProtocolX, :c)) == ["3"]
    @test Bokeh.Model.defaultvalue(ProtocolX, :d) ≡ nothing

    a = ProtocolX(; a = 10, d = "x")
    @test !Bokeh.Model.isdefaultvalue(a, :a)
    @test Bokeh.Model.isdefaultvalue(a, :b)
    @test Bokeh.Model.isdefaultvalue(a, :c)
    @test !Bokeh.Model.isdefaultvalue(a, :d)
end

@testset "bokeh structure" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Int32   = Int32(1)
        b::Float32 = 10f0
    end
    @test fieldnames(X) == (:id, :a, :b, :callbacks)
    @test propertynames(X()) == (:a, :b)
    @test X <: Bokeh.iModel
    @test X().a ≡ one(Int32)
    @test X().b ≡ 10f0

    Z = @Bokeh.model  mutable struct gensym() <: Bokeh.iHasProps
        a::Bokeh.Model.Internal{Int32} = Int32(1)
        b::Float32 = 10f0
    end
    @test Z <: Bokeh.iHasProps
    @test !(Z <: Bokeh.iModel)
    @test fieldnames(Z) == (:id, :a, :b, :callbacks)
    @test propertynames(Z()) == (:a, :b)
    @test Bokeh.Model.bokehproperties(Z) == (:b,)
    @test fieldtype(Z, :a) ≡ Int32
end

@testset "bokeh children" begin
    # `evals` are needed to make sure X1 exists for Y1's declaration
    X1 = @eval @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Int64 = 1
    end

    # `evals` are needed to make sure X1 exists for Y1's declaration
    Y1 = eval(:(@Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Vector{$X1}      = [$X1(; a = 1), $X1(; a = 2)]
        b::Dict{Int64, $X1} = Dict(1 => $X1(; a = 3), 2 => $X1(; a = 4))
        c::Dict{$X1, Int64} = Dict($X1(; a = 5) => 1, $X1(; a = 6) => 2)
        d::Set{$X1}         = Set([$X1(; a = 7), $X1(; a = 8)])
        e::$X1              = $X1(; a = 9)
    end))

    @test propertynames(Y1()) == (:a, :b, :c, :d, :e)
    @test Bokeh.Model.bokehproperties(Y1) == propertynames(Y1())
    @test Bokeh.Model.bokehproperties(Y1; select = :child) == (:e,)
    @test Bokeh.Model.bokehproperties(Y1; select = :children) == (:a, :b, :c, :d)

    y1  = Y1()
    all = Bokeh.allmodels(y1)
    @test Bokeh.bokehid(y1) ∈ keys(all)
    @test Bokeh.bokehid(y1.e) ∈ keys(all)
    @testset for i ∈ (y1.a, values(y1.b), keys(y1.c), y1.d), j ∈ i
        @test Bokeh.bokehid(j) ∈ keys(all)
    end
end

@testset "bokeh dataspec/container" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Bokeh.Model.Spec{Int32}  = Int32(1)
        b::Bokeh.Model.DistanceSpec = 10f0
        c::Vector{Int64}             = Int64[1, 2]
    end
    @test fieldnames(X) == (:id, :a, :b, :c, :callbacks)
    @test propertynames(X()) == (:a, :b, :c)
    @test X <: Bokeh.iModel
    @test X().a ≡ (; value = one(Int32))
    @test X().b ≡ (; value = 10.0)
    @test fieldtype(X, :c) ≡ Vector{Int64}
    @test X().c isa Bokeh.Model.Container{Vector{Int64}}
    @test X().c.values == [1, 2]

    x = X()
    push!(x.c, 10; dotrigger = false)
    @test x.c.values == Int64[1, 2, 10]
    empty!(x.c; dotrigger = false)
    @test isempty(x.c.values)
end

@testset "bokeh restricteddict" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        b::Dict{Bokeh.Model.RestrictedKey{(:a,)}, Int}
    end
    @test fieldtype(X, :b) ≡ Dict{Symbol, Int}
    @test X().b isa Bokeh.Model.Container{Dict{Bokeh.Model.RestrictedKey{(:a,)}, Int64}}

    x = X()
    @nullevents push!(x.b, :mmm => 1)
    @test x.b[:mmm] ≡ 1

    @test_throws KeyError x.b[:a] = 2
end

@testset "bokeh tuple attribute" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Bokeh.Model.Tuple{Bokeh.Model.Spec{Int32},Float64}  = (Int32(1), 2.0)
    end
    @test X().a ≡ ((; value = one(Int32)), 2.0)
    @test fieldtype(X, :a) ≡ Tuple{Bokeh.Model.Spec{Int32}, Float64}
    x = X(; a = ("toto", 4))
    @test x.a == ((; field = "toto"), 4.0)
    @nullevents x.a = (Dict("value" => 10), -1.0)
    @test x.a == ((; value = 10), -1.0)
end

𝐸T = Bokeh.Model.EnumType{(:a, :b, :c)}

@testset "bokeh either attribute" begin
    @test collect(Type, Bokeh.Model.UnionIterator(Union{Symbol, String})) == [Symbol, String]
    @test collect(Type, Bokeh.Model.UnionIterator(Union{Symbol, String, Float32})) == [Float32, Symbol, String]

    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Bokeh.Model.Union{𝐸T, Float64} = "a"
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
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
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
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Bokeh.Model.Color =  :gray
    end
    @test X().a.r ≡ X().a.g ≡ X().a.b ≡ 0x80
    @test X().a.a ≡ 0xff

    @test !ismissing(Bokeh.Model.color("rgb(1, 2, 3)"))
    @test !ismissing(Bokeh.Model.color("#010101"))
    x = X(; a = "rgb(1,2,3)")
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)

    x = X(; a= (1,2,3))
    @test x.a.r ≡ UInt8(1)
    @test x.a.g ≡ UInt8(2)
    @test x.a.b ≡ UInt8(3)
end

@testset "bokeh marker" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        a::Bokeh.Model.MarkerSpec = "x"
    end
    @test X().a == (; value = :x)
    @test X(;a = "fff").a == (; field = "fff")
end

@testset "bokeh complex field" begin
    X = @Bokeh.model mutable struct gensym() <: Bokeh.iModel
        rows::Union{
            Bokeh.enum"max,fit,auto,min",
            Int64,
            Dict{
                Union{Int64, String},
                Union{
                    Bokeh.Model.enum"max,fit,auto,min",
                    Int64,
                    @NamedTuple{
                        policy::Bokeh.Model.enum"auto,min",
                        align::Bokeh.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::Bokeh.Model.enum"fixed",
                        height::Int64,
                        align::Bokeh.Model.enum"start,end,auto,center"
                    },
                    @NamedTuple{
                        policy::Bokeh.Model.enum"max,fit",
                        flex::Float64,
                        align::Bokeh.Model.enum"start,end,auto,center"
                    }
                }
            }
        }
    end
    @test X(; rows = :auto).rows == :auto
    @test X(; rows = 10).rows ≡ 10

    x = X(; rows = Dict(1=>10))
    @test x.rows isa Bokeh.Model.Container{<:Dict}
    @test x.rows[1] ≡ 10

    @nullevents x.rows[1] = :max
    @test x.rows[1] == :max

    @nullevents x.rows[1] = (; policy= :auto, align = :start)
    @test x.rows[1].policy == :auto
    @test x.rows[1].align == :start

    @test_throws ErrorException X(; a = (; policy = :mmm,  align = :start))
end
