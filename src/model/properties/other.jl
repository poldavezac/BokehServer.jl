"""
Allows defining an alias to a given field

```julia
@wrap struct X  <: iModel
    a :: Int = 1
    b :: Alias{A}
end

@assert X(a = 2).b == 2
```
"""
struct Alias{T} <: iProperty end

@inline bokehconvert(T::Type{<:AbstractString}, ν::AbstractString) = ν
@inline bokehfieldtype(T::Type{<:AbstractString}) = T

struct Internal{T} <: iProperty end
@inline bokehfieldtype(𝑇::Type{<:Internal}) = bokehfieldtype(𝑇.parameters[1])

struct ReadOnly{T} <: iProperty end
@inline bokehfieldtype(::Type{ReadOnly{T}}) where {T} = bokehfieldtype(T)
@inline bokehconvert(::Type{ReadOnly{T}}, x::Any) where {T} = bokehconvert(T, x)


struct Nullable{T} <: iProperty end
@inline bokehfieldtype(::Type{Nullable{T}}) where {T} = Union{Nothing, bokehfieldtype(T)}
@inline bokehread(::Type{Nullable{T}}, µ::iHasProps, α::Symbol, ν::Any) where {T} = isnothing(ν) ? nothing : bokehread(T, μ, α, ν)
@inline bokehconvert(::Type{Nullable{T}}, ν::Any) where {T} = isnothing(ν) ? nothing : bokehconvert(T, ν)

struct FontSize <: iProperty end

const FONTSTYLE_PATTERN = r"^[0-9]+(.[0-9]+)?(%|em|ex|ch|ic|rem|vw|vh|vi|vb|vmin|vmax|cm|mm|q|in|pc|pt|px)$"i

@inline bokehfieldtype(::Type{FontSize}) = String

@inline bokehread(::Type{FontSize}, ::iHasProps, ::Symbol, ν::AbstractString) = ν
bokehconvert(::Type{FontSize}, ν::AbstractString) = isnothing(match(FONTSTYLE_PATTERN, ν)) ? Unknown() : ν

macro fontstyle_str(value)
    @assert !isnothing(match(FONTSTYLE_PATTERN, value))
    return value
end

using JSON

struct JSONString end
bokehfieldtype(::Type{JSONString}) = String

function bokehconvert(::Type{JSONString}, ν::AbstractString)
    JSON.parse(ν)  # should thrown an error if not a json string
    return ν
end

struct DashPattern end
bokehfieldtype(::Type{DashPattern}) = Vector{Int64}

const _DASH_SPLIT = r"\s+"
const _DASH_PATTERN = r"^\d+(\s+\d+)*?"

bokehconvert(::Type{DashPattern}, ν::AbstractVector) = collect(Int64, ν)
function bokehconvert(::Type{DashPattern}, ν::AbstractString)
    if isnothing(match(_DASH_PATTERN, ν))
        return bokehconvert(DashPattern, Symbol(ν))
    else
        return parse.(Int64, split(ν, _DASH_SPLIT))
    end
end

function bokehconvert(::Type{DashPattern}, ν::Symbol)
    return if ν == :solid
        Int64[]
    elseif ν == :dashed
        Int64[6]
    elseif ν == :dotted
        Int64[2,4]
    elseif ν == :dotdash
        Int64[2,4,6,4]
    elseif ν == :dashdot
        Int64[6,4,2,4]
    else
        return Unknown()
    end
end

using Base64
struct Base64String end
bokehfieldtype(::Type{Base64String}) = String
bokehconvert(::Type{Base64String}, ν::AbstractString) = String(base64encode(ν))
