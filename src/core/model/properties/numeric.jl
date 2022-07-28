@inline bokehconvert(T::Type{<:Number}, ν::Number) = convert(T, ν)

abstract type iNumeric <: iProperty end
struct Size <: iNumeric end
const Distance = Size
@inline bokehconvert(::Type{Size}, ν::Number) = max(convert(Float64, ν), 0.)
@inline bokehstoragetype(::Type{Size}) = Float64

struct Percent <: iNumeric end
@inline bokehconvert(::Type{Percent}, ν::Number) = clamp(convert(Float64, ν), 0., 1.)
@inline bokehstoragetype(::Type{Percent}) = Float64

struct Interval{L,H} <: iNumeric end
@inline bokehconvert(::Type{Interval{L,H}}, ν::Number) where {L, H} = clamp(convert(Float64, ν), L, H)
@inline bokehstoragetype(::Type{<:Interval}) = Float64

const Alpha = Percent
const Angle = Float64

struct PositiveInt <: iNumeric end

@inline bokehconvert(::Type{PositiveInt}, ν::Number) = max(convert(Int64, ν), 1)
@inline bokehstoragetype(::Type{PositiveInt}) = Int64

struct NonNegativeInt <: iNumeric end

@inline bokehconvert(::Type{NonNegativeInt}, ν::Number) = max(convert(Int64, ν), 0)
@inline bokehstoragetype(::Type{NonNegativeInt}) = Int64

using Dates
bokehconvert(::Type{Float64}, ν::DateTime) = convert(Float64, Dates.datetime2epochms(ν))
bokehconvert(::Type{Float64}, ν::Date)     = convert(Float64, Dates.datetime2epochms(DateTime(ν)))
bokehconvert(::Type{Float64}, ν::Period)   = convert(Float64, Dates.Millisecond(ν).value)
bokehconvert(::Type{Float64}, ν::Time)     = convert(Float64, Dates.Millisecond(ν.instant).value)

struct MinMaxBounds <: iNumeric end
bokehstoragetype(::Type{MinMaxBounds}) = Union{
    Symbol,
    Tuple{Float64, Union{Nothing, Float64}},
    Tuple{Union{Nothing, Float64}, Float64}
}

bokehconvert(::Type{MinMaxBounds}, ν::Symbol) = ν ≡ :auto ? :auto : Unknown()
bokehconvert(::Type{MinMaxBounds}, ν::AbstractString) = ν == "auto" ? :auto : Unknown()
function bokehconvert(::Type{MinMaxBounds}, ν::Tuple{<:Any, <:Any})
    ν1 = ν2 = nothing
    isnothing(ν[1]) || (ν1 = bokehconvert(Float64, ν[1]))
    isnothing(ν[2]) || (ν2 = bokehconvert(Float64, ν[2]))
    ((ν1 isa Unknown) || (ν2 isa Unknown)) && return Unknown()
    isnothing(ν1) && isnothing(ν2) && return nothing

    if !isnothing(ν1) && !isnothing(ν2) && (ν1 > ν2)
        throw(BokehException("MinMaxBounds $ν should be in ascending order"))
    end
    return (ν1, ν2)
end
