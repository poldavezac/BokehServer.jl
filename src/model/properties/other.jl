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

struct Internal{T} <: iProperty end
@inline bokehfieldtype(𝑇::Type{<:Internal}) = bokehfieldtype(𝑇.parameters[1])

struct ReadOnly{T} <: iProperty end
@inline bokehfieldtype(::Type{ReadOnly{T}}) where {T} = bokehfieldtype(T)
@inline bokehwrite(::Type{<:ReadOnly}, @nospecialize(ν)) = throw(ErrorException("Readonly attribute"))


struct Nullable{T} <: iProperty end
@inline bokehfieldtype(::Type{Nullable{T}}) where {T} = Union{Nothing, bokehfieldtype(T)}
@inline bokehwrite(::Type{<:Nullable}, @nospecialize(µ::iHasProps), α::Symbol, ::Nothing) = nothing
@inline bokehwrite(::Type{Nullable{T}}, ν) where{T} = bokehwrite(T, ν)

struct FontSize <: iProperty end

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

struct Either{T} <: iProperty end

bokehfieldtype(𝑇::Type{<:Either}) = Union{𝑇.parameters...}

@generated function bokehwrite(𝑇::Type{<:Either}, ν)
    _👻elseif(𝑇.parameters[1].parameters, :(throw(ErrorException("Can't deal with $𝑇 = $ν")))) do T
        :(if applicable(bokehwrite, $T, ν)
            bokehwrite($T, ν)
        end)
    end
end

bokehfieldtype(𝑇::Type{<:Tuple}) = Tuple{(bokehfieldtype(T) for T ∈ 𝑇.parameters)...}
@generated function bokehwrite(𝑇::Type{<:Tuple}, ν::Union{Vector, Tuple})
    quote
        tuple($((:(bokehwrite($T, ν[$i])) for (i, T) ∈ enumerate(𝑇.parameters[1].parameters))...))
    end
end
