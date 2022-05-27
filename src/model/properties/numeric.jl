struct Size end
const Distance = Size
bokehwrite(::Type{Size}, ::iHasProps, ::Symbol, ν) = max(ν, 0.)
bokehfieldtype(::Type{Size}) = Float64

struct Percent end
bokehwrite(::Type{Percent}, ::iHasProps, ::Symbol, ν) = clamp(ν, 0., 1.)
bokehfieldtype(::Type{Percent}) = Float64

struct Interval{L,H} end
bokehwrite(::Type{Interval{L,H}}, ::iHasProps, ::Symbol, ν) where {L, H} = clamp(ν, L, H)
bokehfieldtype(::Type{Percent}) = Float64

const Alpha = Percent
const Angle = Float64

struct PositiveInt end
bokehwrite(::Type{PositiveInt}, ::iHasProps, ::Symbol, ν) = max(ν, 0)
bokehfieldtype(::Type{PositiveInt}) = Int64
