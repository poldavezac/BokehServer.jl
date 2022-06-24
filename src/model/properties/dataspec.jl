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
            get(kwa, :value, missing), get(kwa, :field, missing),
            get(kwa, :expr, missing),  get(kwa, :transform, missing),
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
            $((isunits ? (:(units :: $(code.args[2].args[2].args[end])),) : ())...)
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

@dataspec struct DistanceSpec <: iUnitSpec{Distance, SpatialUnits}
    value::Float64
end

speceltype(::Type{<:iSpec{T}})          where {T}    = T
specunittype(::Type{<:iUnitSpec{T, K}}) where {T, K} = K
units(::Type{<:iUnitSpec{T, K}})        where {T, K} = values(K)

function _👻specvalue(𝑇::Type, α, ν)
    value = get(ν, α, missing)
    return ismissing(value) ? missing : bokehconvert(𝑇, value)
end

function bokehconvert(𝑇::Type{<:iSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ fieldnames(𝑇)) && return Unknown()
    value = _👻specvalue(speceltype(𝑇), :value, ν)
    (value isa Unknown) && return Unknown
    𝑇(; (i => get(ν, i, missing) for i ∈ (:field, :expr, :transform))..., value)
end

function bokehconvert(𝑇::Type{<:iUnitSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ fieldnames(𝑇)) && return Unknown()
    value = _👻specvalue(speceltype(𝑇), :value, ν)
    (value isa Unknown) && return Unknown

    unt = _👻specvalue(specunittype(𝑇), :units, ν)
    (unt isa Unknown) && return Unknown
    𝑇(; (i => get(ν, i, missing) for i ∈ (:field, :expr, :transform))..., value, unt)
end

function bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractDict{<:AbstractString})
    bokehconvert(𝑇, Dict{Symbol, Any}((Symbol(i) => j for (i, j) ∈ ν)))
end

function bokehconvert(𝑇::Type{<:iSpec}, ν)
    value = bokehconvert(speceltype(𝑇), ν)
    return value isa Unknown ? value : 𝑇(; value)
end

bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractString) = 𝑇(; field = string(ν))

function bokehconvert(𝑇::Type{<:Spec{<:EnumType}}, ν::AbstractString)
    value = bokehconvert(speceltype(𝑇), ν)
    return value isa Unknown ? 𝑇(; field = string(ν)) : 𝑇(; value)
end

function Base.getproperty(μ::iSpec{<:EnumType}, σ::Symbol)
    val = getfield(μ, σ)
    return ismissing(val) || σ ≢ :value ? val : val.value
end

function Base.getproperty(μ::iUnitSpec, σ::Symbol)
    val = getfield(μ, σ)
    return ismissing(val) || σ ≢ :units ? val : val.value
end

function bokehread(::Type{T}, ::iHasProps, ::Symbol, ν::T) where {T <: iSpec}
    return (; (i=>getproperty(ν, i) for i ∈ fieldnames(T) if !ismissing(getfield(ν, i)))...)
end

function bokehread(::Type{T}, ::iHasProps, ::Symbol, ν::T) where {T <: iUnitSpec}
    fields = fieldnames(ν.units ≡ units(T)[1] ? Spec : UnitSpec)
    return (; (i=>getproperty(ν, i) for i ∈ fields if !ismissing(getfield(ν, i)))...)
end

for cls ∈ (:FontSize, :Size, :Alpha)
    @eval @dataspec struct $(Symbol("$(cls)Spec")) <: iSpec{$cls} end
end

for 𝑇 ∈ (:LineCap, :LineDash, :LineJoin, :MarkerType, :TextAlign, :TextBaseline, :HatchPatternType, :FontStyle)
    @eval const $(Symbol(replace("$𝑇", "Type"=>"")*"Spec")) = Spec{$𝑇}
    @eval Base.show(io::IO, ::Type{Spec{$𝑇}}) = print(io::IO, $("Bokeh.Model.$(replace("$𝑇", "Type"=>""))Spec"))
end

const NumberSpec       = Spec{Float64}
const AngleSpec        = UnitSpec{Float64, AngleUnits}
const NullDistanceSpec = Nullable{DistanceSpec}
const NullStringSpec   = Nullable{Spec{String}}
const ColorSpec        = Spec{Color}

for 𝑇 ∈ (:NumberSpec, :AngleSpec, :NullDistanceSpec, :NullStringSpec, :ColorSpec)
    @eval Base.show(io::IO, ::Type{$𝑇}) = print(io::IO, $("Bokeh.Model.$𝑇"))
end

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
    if !ismissing(value)
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
