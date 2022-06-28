abstract type iSpec{T} <: iProperty end
abstract type iUnitSpec{T, K} <: iSpec{T} end

struct Column
    item :: String
end

const SpecItemType      = Union{T, Column, iModel} where {T}
const SpecTransformType = Union{iModel, Missing}

for (cls, 𝑇) ∈ (
    :IntSpec          => Int64,
    :NumberSpec       => Float64,
    :StringSpec       => String,
    :HatchPatternSpec => HatchPatternType, 
    :MarkerSpec       => MarkerType, 
    (
        Symbol("$(cls)Spec") => getfield(Model, cls)
        for cls ∈ (
            :FontSize, :Size, :Alpha, :Color, :DashPattern, :FontStyle,
            :LineCap, :LineDash, :LineJoin, :TextAlign, :TextBaseline
        )
    )...,
)
    @eval struct $cls <: iSpec{$𝑇}
        item      :: SpecItemType{$(bokehfieldtype(𝑇))}
        transform :: SpecTransformType
        $cls(item, transform = missing) = new(item, transform)
    end
end

for (cls, (𝑇, 𝑈)) ∈ (
    :DistanceSpec      => Distance => SpatialUnits,
    :PropertyUnitsSpec => Float64  => SpatialUnits,
    :AngleSpec         => Float64  => AngleUnits,
)
    @eval struct $cls <: iUnitSpec{$𝑇, $𝑈}
        item      :: SpecItemType{$(bokehfieldtype(𝑇))}
        transform :: SpecTransformType
        units     :: $𝑈
        $cls(item, transform = missing, units = $(Meta.quot(values(𝑈)[1]))) =
            new(item, transform, units)
    end
end

for 𝑇 ∈ (:DistanceSpec, :StringSpec)
    @eval const $(Symbol("Null$𝑇")) = Nullable{$𝑇}
    @eval Base.show(io::IO, ::Type{$𝑇}) = print(io::IO, $("Bokeh.Model.Null$𝑇"))
end

speceltype(::Type{<:iSpec{T}})          where {T}    = T
specunittype(::Type{<:iUnitSpec{T, K}}) where {T, K} = K
units(::Type{<:iUnitSpec{T, K}})        where {T, K} = values(K)

function bokehconvert(𝑇::Type{<:iSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ (:value, :field, :expr, :transform)) && return Unknown()
    item = _👻specvalue(speceltype(𝑇), :value, ν, missing)
    if item isa Unknown
        return item

    elseif ismissing(item)
        item = let val = get(ν, :field, missing)
            ismissing(val) ? get(ν, :expr, missing) : Column(val)
        end
    end
    return 𝑇(item, get(ν, :transform, missing))
end

function bokehconvert(𝑇::Type{<:iUnitSpec}, ν::Union{AbstractDict{Symbol}, NamedTuple})
    (keys(ν) ⊈ (:value, :field, :expr, :transform, :units)) && return Unknown()
    item = _👻specvalue(speceltype(𝑇), :value, ν, missing)
    if item isa Unknown
        return item

    elseif ismissing(item)
        item = let val = get(ν, :field, missing)
            ismissing(val) ? get(ν, :expr, missing) : Column(val)
        end
    end

    unt = _👻specvalue(specunittype(𝑇), :units, ν, units(𝑇)[1])
    return if unt isa Unknown
        unt
    else
        𝑇(item, get(ν, :transform, missing), unt)
    end
end

function bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractDict{<:AbstractString})
    bokehconvert(𝑇, Dict{Symbol, Any}((Symbol(i) => j for (i, j) ∈ ν)))
end

function bokehconvert(𝑇::Type{<:iSpec}, ν)
    item = bokehconvert(speceltype(𝑇), ν)
    return item isa Unknown ? item : 𝑇(item)
end

bokehconvert(𝑇::Type{<:iSpec}, ν::AbstractString) = 𝑇(Column(ν))

function bokehconvert(𝑇::Type{<:iSpec{<:EnumType}}, ν::AbstractString)
    value = bokehconvert(speceltype(𝑇), ν)
    return 𝑇(value isa Unknown ? Column(ν) : value)
end

function bokehread(::Type{<:iSpec}, ::iHasProps, ::Symbol, ν)
    out = tonamedtuple(ν)
    return length(out) ≡ 1 ? first(out) : out
end

bokehread(::Type{<:iSpec{String}}, ::iHasProps, ::Symbol, ν) = tonamedtuple(ν)
bokehread(::Type{PropertyUnitsSpec}, ::iHasProps, ::Symbol, ν) = tonamedtuple(ν)

function tonamedtuple(ν::iSpec)
    item      = ν.item
    transform = ν.transform
    out       = item isa Column ? (; field = item.item) : item isa iModel ? (; expr = item) : (; value = item)
    return ismissing(transform) ? out : merge(out, (; transform))
end

function tonamedtuple(ν::iUnitSpec)
    out  = invoke(tonamedtuple, Tuple{iSpec}, ν)
    unts = ν.units.value
    return unts ≡ units(typeof(ν))[1] ? out : merge(out, (; units = unts))
end

function _👻specvalue(𝑇::Type, α, ν, dflt)
    value = get(ν, α, dflt)
    return ismissing(value) ? dflt : bokehconvert(𝑇, value)
end
