abstract type iSpec{T} end

function _spec_fields(T, others...)
    quote
        value     :: Union{$T,      Missing}
        field     :: Union{String, Missing}
        expr      :: Union{iModel, Missing}
        transform :: Union{iModel, Missing}
        $(others...)
    end
end

function _spec_constructor(cls, others...)
    quote
        function $cls(kwa...) where {$(cls.args[2:end]...)}
            out = new($((
                :(get(kwa, $(Meta.quot(i)), missing))
                for i ∈ (:value, :field, :expr, :transform, others...)
            )...))
            @assert(
                xor(ismissing(out.value), ismissing(out.field)),
                "One of value or field must be provided"
            )
            out
        end
    end
end

@eval struct Spec{T} <: iSpec{T}
    $(_spec_fields(:T))
    $(_spec_constructor(:(Spec{T})))
end

@eval struct UnitSpec{T, K} <: iSpec{T}
    $(_spec_fields(:T, :(unit::Symbol)))
    $(_spec_constructor(:(UnitSpec{T, K}), :unit))
end

@eval struct EnumSpec{T} <: iSpec{Symbol}
    $(_spec_fields(Symbol))
    $(_spec_constructor(:(EnumSpec{T})))
end

Base.eltype(::Type{<:iSpec{T}}) where {T} = T
longform(::Type{<:EnumSpec}, ν::String)         = longform(Symbol(ν))
longform(::Type{<:EnumSpec}, ν::Symbol)         = ν
Base.values(::Type{<:EnumSpec{T}}) where {T}    = T
Base.in(ν::Symbol, T::Type{<:EnumSpec})         = longform(ν) ∈ values(T)
Base.in(ν::AbstractString, T::Type{<:EnumSpec}) = Symbol(ν) ∈ T
units(::Type{UnitSpec{T, K}}) where {T, K} = K

function bokehwrite(
        T::Type{<:iSpec},
        µ::iHasProps,
        α::Symbol,
        ν::Union{Dict{Symbol}, NamedTuple},
)
    value = get(ν, :value, missing)
    ismissing(value) || (value = bokehwrite(eltype(T), µ, α, value))
    T(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value)
end

function bokehwrite(
        T::Type{<:UnitSpec},
        µ::iHasProps,
        α::Symbol,
        ν::Union{Dict{Symbol}, NamedTuple},
)
    value = get(ν, :value, missing)
    ismissing(value) || (value = bokehwrite(eltype(T), µ, α, value))
    un    = get(ν, :units, units(T)[1])
    @assert un ∈ units(T)
    T(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value, units)
end

function bokehwrite(T::Type{<:iSpec}, µ::iHasProps, α::Symbol, ν::Dict{String})
    bokehwrite(T, µ, α, Dict{Symbol, Any}((Symbol(i) => j for (i, j) ∈ ν)))
end

function bokehwrite(T::Type{<:iSpec}, µ::iHasProps, α::Symbol, ν::Union{Symbol, Number})
    T(; value = bokehwrite(T.parameters[1], µ, α, ν))
end

bokehwrite(𝑇::Type{<:iSpec{<:Number}}, ν::AbstractString) = 𝑇(; field = string(ν))

function bokehread(T::Type{<:Spec}, ν)
    @assert typeof(ν) ≡ T
    @assert xor(ismissing(ν.value), ismissing(ν.field))
    return (; (i=>getfield(ν, i) for i ∈ fiednames(T) if !ismissing(getfield(ν, i)))...)
end

function bokehread(T::Type{<:UnitSpec}, ν)
    @assert typeof(ν) ≡ T
    @assert xor(ismissing(ν.value), ismissing(ν.field))
    @assert ν.units ∈ units(T)
    fields = fieldnames(ν.units ≡ units(T)[1] ? Spec : UnitSpec)
    return (; (i=>getfield(ν, i) for i ∈ fields if !ismissing(getfield(ν, i)))...)
end

function bokewrite(T::Type{<:EnumSpec}, ν)
    value = longform(ν)
    return value ∈ T ? (; value) : (; field = String(ν))
end

const LineCapSpec      = EnumSpec{(:butt, :round, :square)}
const LineDashSpec     = EnumSpec{(:solid, :dashed, :dotted, :dotdash, :dashdot)}
const LineJoinSpec     = EnumSpec{(:miter, :round, :bevel)}
const MarkerSpec       = EnumSpec{values(MarkerType)}
const TextAlignSpec    = EnumSpec{(:left, :right, :center)}
const TextBaselineSpec = EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)}
const HatchPatternSpec = EnumSpec{values(HatchPatternType)}
const FontStyleSpec    = EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))}
const DistanceSpec     = UnitSpec{Distance, (:data, :screen)}
const ColorSpec        = Spec{Color}
const NullDistanceSpec = Nullable{DistanceSpec}
const NullStringSpec   = Nullable{Spec{String}}

function bokehwrite(::Type{ColorSpec}, ::iHasProps, ::Symbol, ν::Union{Dict{Symbol}, NamedTuple})
    value = get(ν, :value, missing)
    ismissing(value) || (value = Color(value))
    ColorSpec(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value)
end

function bokehwrite(::Type{ColorSpec}, ::iHasProps, ::Symbol, ν::AbstractString)
    value = color(v)
    return ismissing(value) : ColorSpec(; field = string(ν)) : ColorSpec(; value)
end

bokehwrite(::Type{ColorSpec}, ::iHasProps, ::Symbol, ν) = ColorSpec(; value = Color(v))
