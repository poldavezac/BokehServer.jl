"""
Allows defining an alias to a given field

```julia
@model struct X  <: iModel
    a :: Int = 1
    b :: Alias{A}
end

@assert X(a = 2).b == 2
```
"""
struct Alias{T} <: iProperty end

@inline bokehwrite(T::Type{<:AbstractString}, ν::AbstractString) = ν
@inline bokehfieldtype(T::Type{<:AbstractString}) = T

struct Internal{T} <: iProperty end
@inline bokehfieldtype(𝑇::Type{<:Internal}) = bokehfieldtype(𝑇.parameters[1])

struct ReadOnly{T} <: iProperty end
@inline bokehfieldtype(::Type{ReadOnly{T}}) where {T} = bokehfieldtype(T)
@inline bokehwrite(::Type{<:ReadOnly}, ::Any) = throw(ErrorException("Readonly attribute"))


struct Nullable{T} <: iProperty end
@inline bokehfieldtype(::Type{Nullable{T}}) where {T} = Union{Nothing, bokehfieldtype(T)}
@inline bokehread(::Type{<:Nullable}, ::iHasProps, ::Symbol, ::Nothing) = nothing
@inline bokehread(::Type{Nullable{T}}, µ::iHasProps, α::Symbol, ν::Any) where {T} = bokehread(T, μ, α, ν)
@inline bokehwrite(::Type{<:Nullable}, ν::Nothing) = nothing
@inline bokehwrite(::Type{Nullable{T}}, ν::Any) where {T} = bokehwrite(T, ν)

struct FontSize <: iProperty end

const FONTSTYLE_PATTERN = r"^[0-9]+(.[0-9]+)?(%|em|ex|ch|ic|rem|vw|vh|vi|vb|vmin|vmax|cm|mm|q|in|pc|pt|px)$"i

@inline bokehfieldtype(::Type{FontSize}) = String

@inline bokehread(::Type{FontSize}, ::iHasProps, ::Symbol, ν::AbstractString) = ν
bokehwrite(::Type{FontSize}, ν::AbstractString) = isnothing(match(FONTSTYLE_PATTERN, ν)) ? Unknown() : ν

macro fontstyle_str(value)
    @assert !isnothing(match(FONTSTYLE_PATTERN, value))
    return value
end
