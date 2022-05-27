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
struct Alias{T} end

struct Internal{T} end
@inline bokehfieldtype(::Type{Internal{T}}) where {T} = T

struct ReadOnly{T} end
@inline bokehfieldtype(::Type{ReadOnly{T}}) where {T} = bokehfieldtype(T)
@inline bokehwrite(::Type{<:ReadOnly}, @nospecialize(ν)) = throw(ErrorException("Readonly attribute"))


struct Nullable{T} end
@inline bokehfieldtype(::Type{Nullable{T}}) where {T} = Union{Nothing, bokehfieldtype(T)}
@inline bokehwrite(::Type{<:Nullable}, @nospecialize(µ::iHasProps), α::Symbol, ::Nothing) = nothing
@inline bokehwrite(::Type{Nullable{T}}, µ::iHasProps, α::Symbol, ν) where{T} = bokehwrite(T, µ, α, ν)

struct FontSize end

const FONTSTYLE_PATTERN = r"^[0-9]+(.[0-9]+)?(%|em|ex|ch|ic|rem|vw|vh|vi|vb|vmin|vmax|cm|mm|q|in|pc|pt|px)$"i
@inline bokehfieldtype(::Type{FontSize}) = String
function bokehwrite(::Type{FontSize}, ν::AbstractString)
    @assert !isnothing(match(FONTSTYLE_PATTERN, ν))
    return ν
end

macro fontstyle_str(value)
    @assert !isnothing(match(FONTSTYLE_PATTERN, value))
    return value
end
