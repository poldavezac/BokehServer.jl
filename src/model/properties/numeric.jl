struct Size <: iProperty end
const Distance = Size
@inline bokehwrite(::Type{Size}, ν) = max(convert(Float64, ν), 0.)
@inline bokehfieldtype(::Type{Size}) = Float64

struct Percent <: iProperty end
@inline bokehwrite(::Type{Percent}, ν) = clamp(convert(Float64, ν), 0., 1.)
@inline bokehfieldtype(::Type{Percent}) = Float64

struct Interval{L,H} <: iProperty end
@inline bokehwrite(::Type{Interval{L,H}}, ν) where {L, H} = clamp(convert(Float64, ν), L, H)
@inline bokehfieldtype(::Type{<:Interval}) = Float64

const Alpha = Percent
const Angle = Float64

struct PositiveInt <: iProperty end

@inline bokehwrite(::Type{PositiveInt}, ν) = max(convert(Int64, ν), 1)
@inline bokehfieldtype(::Type{PositiveInt}) = Int64

struct NonNegativeInt <: iProperty end

@inline bokehwrite(::Type{NonNegativeInt}, ν) = max(convert(Int64, ν), 0)
@inline bokehfieldtype(::Type{NonNegativeInt}) = Int64
