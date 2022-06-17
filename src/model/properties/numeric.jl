@inline bokehwrite(T::Type{<:Number}, ν::Number) = convert(T, ν)

struct Size <: iProperty end
const Distance = Size
@inline bokehwrite(::Type{Size}, ν::Number) = max(convert(Float64, ν), 0.)
@inline bokehfieldtype(::Type{Size}) = Float64

struct Percent <: iProperty end
@inline bokehwrite(::Type{Percent}, ν::Number) = clamp(convert(Float64, ν), 0., 1.)
@inline bokehfieldtype(::Type{Percent}) = Float64

struct Interval{L,H} <: iProperty end
@inline bokehwrite(::Type{Interval{L,H}}, ν::Number) where {L, H} = clamp(convert(Float64, ν), L, H)
@inline bokehfieldtype(::Type{<:Interval}) = Float64

const Alpha = Percent
const Angle = Float64

struct PositiveInt <: iProperty end

@inline bokehwrite(::Type{PositiveInt}, ν::Number) = max(convert(Int64, ν), 1)
@inline bokehfieldtype(::Type{PositiveInt}) = Int64

struct NonNegativeInt <: iProperty end

@inline bokehwrite(::Type{NonNegativeInt}, ν::Number) = max(convert(Int64, ν), 0)
@inline bokehfieldtype(::Type{NonNegativeInt}) = Int64

using Dates
bokehwrite(::Type{Float64}, ν::DateTime) = convert(Float64, Dates.datetime2epochms(ν))
bokehwrite(::Type{Float64}, ν::Date)     = convert(Float64, Dates.datetime2epochms(DateTime(ν)))
bokehwrite(::Type{Float64}, ν::Period)   = convert(Float64, round(ν, Dates.Milliseconds).value)

struct MinMaxBounds end
bokehfieldtype(::Type{MinMaxBounds}) = Union{
    Symbol,
    Tuple{Float64, Nullable{Float64}},
    Tuple{Nullable{Float64}, Float64}
}

bokehwrite(::Type{MinMaxBounds}, ν::Symbol) = ν ≡ :auto ? :auto : Unknown()
function bokehwrite(::Type{MinMaxBounds}, ν::Tuple{<:Any, <:Any})
    ν1 = ν2 = nothing
    isnothing(ν[1]) || (ν1 = bokehwrite(Float64, ν[1]))
    isnothing(ν[2]) || (ν2 = bokehwrite(Float64, ν[2]))
    ((ν1 isa Unknown) || (ν2 isa Unknown)) && return Unknown()
    isnothing(ν1) && isnothing(ν2) && return nothing

    if !isnothing(ν1) && !isnothing(ν2) && (ν1 > ν2)
        throw(ErrorException("MinMaxBounds $ν should be in ascending order"))
    end
    return (ν1, ν2)
end
