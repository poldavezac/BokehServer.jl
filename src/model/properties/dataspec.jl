abstract type iSpec{T} <: iProperty end
abstract type iUnitSpec{T, K} <: iSpec{T} end

macro dataspec(code::Expr)
    cls       = code.args[2].args[1]
    isunits   = code.args[2].args[2].args[1] ≡ :iUnitSpec

    valuetype = let opts = filter(code.args[end].args) do i
            i isa Expr && i.head ≡ :(::) && i.args[1] ≡ :value
        end
        if (length(opts) > 1)
            throw(ErrorException("Could not create dataspec"))
        elseif length(opts) ≡ 1
            opts[1].args[2]
        else
            valuetype = bokehfieldtype(__module__.eval(code.args[2].args[2].args[2]))
        end
    end

    construction = :(let out = new(
            $((
                :(let x = get(kwa, $(Meta.quot(i)), missing)
                    isnothing(x) ? missing : x
                end)
                for i ∈ (:value, :field, :expr, :transform)
            )...),
            $((isunits ? (:units,) : ())...)
        )
        @assert(
            xor(ismissing(out.value), ismissing(out.field)),
            "One of value or field must be provided"
        )
        out
    end)

    constructor = if isunits
        :($cls(; units = Bokeh.Model.units($cls)[1], kwa...) = $construction)
    else
        :($cls(; kwa...) = $construction)
    end
    (cls isa Symbol) || (constructor.args[1] = :($(constructor.args[1]) where {$(cls.args[2:end]...)}))

    esc(quote
        struct $(code.args[2])
            value     :: Union{$valuetype, Missing}
            field     :: Union{String, Missing}
            expr      :: Union{iModel, Missing}
            transform :: Union{iModel, Missing}
            $((isunits ? (:(units :: Symbol),) : ())...)

            $constructor
        end
    end)
end

@dataspec struct Spec{T} <: iSpec{T}
    value::T
end

@dataspec struct UnitSpec{T, K} <: iUnitSpec{T, K}
    value::T
end

@dataspec struct EnumSpec{T} <: iSpec{Symbol}
    value::Symbol
end

@dataspec struct DistanceSpec <: iUnitSpec{Distance, (:data, :screen)}
    value::Float64
end

speceltype(::Type{<:iSpec{T}}) where {T}        = T
longform(𝑇::Type{<:EnumSpec}, ν::String)        = longform(𝑇, Symbol(ν))
longform(::Type{<:EnumSpec}, ν::Symbol)         = ν
Base.values(::Type{<:EnumSpec{T}}) where {T}    = T
Base.in(ν::Symbol, 𝑇::Type{<:EnumSpec})         = longform(𝑇, ν) ∈ values(𝑇)
Base.in(ν::AbstractString, 𝑇::Type{<:EnumSpec}) = Symbol(ν) ∈ 𝑇
units(::Type{<:iUnitSpec{T, K}}) where {T, K}   = K

function bokehconvert(𝑇::Type{<:iSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ fieldnames(𝑇)) && return Unknown()

    value = get(ν, :value, missing)
    ismissing(value) || (value = bokehconvert(speceltype(𝑇), value))
    𝑇(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value)
end

function bokehconvert(𝑇::Type{<:iUnitSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ fieldnames(𝑇)) && return Unknown()

    value = get(ν, :value, missing)
    ismissing(value) || (value = bokehconvert(speceltype(𝑇), value))
    ismissing(get(ν, :units, missing)) && (ν[:units] = first(units(𝑇)))
    @assert ν[:units] ∈ units(𝑇)
    𝑇(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value)
end

bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractDict{<:AbstractString}) = bokehconvert(𝑇, Dict{Symbol, Any}((Symbol(i) => j for (i, j) ∈ ν)))

function bokehconvert(𝑇::Type{<:iSpec}, ν)
    value = bokehconvert(speceltype(𝑇), ν)
    return value isa Unknown ? value : 𝑇(; value)
end

bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractString) = 𝑇(; field = string(ν))

function bokehread(::Type{T}, ::iHasProps, ::Symbol, ν::T) where {T <: iSpec}
    @assert xor(ismissing(ν.value), ismissing(ν.field))
    return (; (i=>getfield(ν, i) for i ∈ fieldnames(T) if !ismissing(getfield(ν, i)))...)
end

function bokehread(::Type{T}, ::iHasProps, ::Symbol, ν::T) where {T <: iUnitSpec}
    @assert xor(ismissing(ν.value), ismissing(ν.field))
    @assert ν.units ∈ units(T)
    fields = fieldnames(ν.units ≡ units(T)[1] ? Spec : UnitSpec)
    return (; (i=>getfield(ν, i) for i ∈ fields if !ismissing(getfield(ν, i)))...)
end

bokehconvert(𝑇::Type{<:EnumSpec}, ν::AbstractString) = bokehconvert(𝑇, Symbol(ν))
function bokehconvert(𝑇::Type{<:EnumSpec}, ν::Symbol)
    value = longform(𝑇, ν)
    return value ∈ 𝑇 ? 𝑇(; value) : 𝑇(; field = String(ν))
end

for cls ∈ (:FontSize, :Size, :Alpha)
    @eval @dataspec struct $(Symbol("$(cls)Spec")) <: iSpec{$cls} end
end

const NumberSpec       = Spec{Float64}
const AngleSpec        = UnitSpec{Float64, (:rad, :deg, :grad, :turn)}
const LineCapSpec      = EnumSpec{(:butt, :round, :square)}
const LineDashSpec     = EnumSpec{(:solid, :dashed, :dotted, :dotdash, :dashdot)}
const LineJoinSpec     = EnumSpec{(:miter, :round, :bevel)}
const MarkerSpec       = EnumSpec{values(MarkerType)}
const TextAlignSpec    = EnumSpec{(:left, :right, :center)}
const TextBaselineSpec = EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)}
const HatchPatternSpec = EnumSpec{values(HatchPatternType)}
const FontStyleSpec    = EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))}
const NullDistanceSpec = Nullable{DistanceSpec}
const NullStringSpec   = Nullable{Spec{String}}
const ColorSpec        = Spec{Color}

@dataspec struct DashPatternSpec <: iSpec{DashPattern}
    value::Vector{Int64}
end

struct PropertyUnitsSpec <: iSpec{Float64}
    value     :: Union{Float64, Missing}
    field     :: Union{String, Missing}
    expr      :: Union{iModel, Missing}
    transform :: Union{iModel, Missing}
    units     :: Union{Symbol, Missing}

    PropertyUnitsSpec(;
            value = missing, field = missing, expr = missing, transform = missing, units = :data
    ) = new(
        (ismissing(value)   || isnothing(value)) ? missing : convert(Float64, value),
        (ismissing(field)   || isnothing(field)) ? missing : "$field",
        isnothing(expr)                          ? missing : expr,
        isnothing(transform)                     ? missing : transform,
        (ismissing(units)   || isnothing(units)) ? missing : Symbol(units)
    )
end

function bokehconvert(::Type{ColorSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ fieldnames(ColorSpec)) && return Unknown()
    value = get(ν, :value, missing)
    if ismissing(value)
        value = color(value)
        ismissing(value) && return Unknown()
    end

    ColorSpec(; (i => j for (i, j) ∈ zip(keys(ν), values(ν)))..., value)
end

function bokehconvert(::Type{ColorSpec}, ν::AbstractString)
    value = color(ν)
    return ismissing(value) ? ColorSpec(; field = string(ν)) : ColorSpec(; value)
end

function bokehconvert(::Type{ColorSpec}, ν::COLOR_ARGS)
    value = color(ν)
    ismissing(value) ? Unknown() : ColorSpec(; value)
end
