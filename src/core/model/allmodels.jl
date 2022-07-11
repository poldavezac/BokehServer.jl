for (name, tpe, checkkey, pushkey) ∈ (
    (:bokehmodels, Dict{Int64, iHasProps}, (x)->:(haskey(found, $x)), :(push!(found, bokehid(cur) => cur))),
    (:bokehids, Set{Int64}, (x) -> :($x ∈ found), :(push!(found, bokehid(cur))))
)
@eval function $name(μ::Vararg{iHasProps}) :: $tpe
        found = $tpe()
        todos = collect(iHasProps, μ)
        while !isempty(todos)
            cur = pop!(todos)
            key = bokehid(cur)
            $(checkkey(:key)) && continue
            $pushkey

            for child ∈ bokehchildren(cur)
                $(checkkey(:(bokehid(child)))) || push!(todos, child) 
            end
        end
        found
    end
    @eval $name(μ::Union{AbstractSet{<:iHasProps}, AbstractArray{<:iHasProps}}) :: $tpe = $name(μ...)
end

"""
    models(𝐹::Function, μ::Vararg{iHasProps})

Iterate through all models and lets the user do
something about it.

# Examples

```
# get all models (same as `bokehmodels`)
mylist = Any[]
models((x)->push!(mylist, x), myobj)
```

```
# get all glyphs
mylist = Models.iGlyph[]
models((x::Models.iGlyph)->push!(mylist, x), myobj)
```
"""
function models(𝐹::Function, μ::Vararg{iHasProps})
    found = Set{Int64}()
    todos = collect(iHasProps, μ)
    while !isempty(todos)
        cur = pop!(todos)
        key = bokehid(cur)
        (key ∈ found)  && continue
        push!(found, key)
        applicable(𝐹, cur) && 𝐹(cur)

        for child ∈ bokehchildren(cur)
            (bokehid(child) ∈ found) || push!(todos, child) 
        end
    end
end

"""
    filtermodels(𝐹::Function, μ::Vararg{iHasProps})
    filtermodels(𝑇::Type{<:iHasProps}, μ::Vararg{iHasProps})
    filtermodels(𝐹::Function, 𝑇::Type{<:iHasProps}, μ::Vararg{iHasProps})

Collects models accepted by predicate `𝐹`.

# Examples

```
# get all models (same as `bokehmodels`)
filtermodels((x)-> true, myobj)
```

```
filtermodels((x)-> x isa Models.iGlyph, myobj)
filtermodels(Models.iGlyph, myobj)
```
"""
function filtermodels(𝐹::Function, μ::Vararg{iHasProps})
    lst = iHasProps[]
    models((x) -> applicable(𝐹, x) && 𝐹(x) && push!(lst, x), μ...)
    return lst
end

function filtermodels(𝑇::Type{<:iHasProps}, μ::Vararg{iHasProps})
    lst = 𝑇[]
    models((x) -> (x isa 𝑇) && push!(lst, x), μ...)
    return lst
end

function filtermodels(𝐹::Function, 𝑇::Type{<:iHasProps}, μ::Vararg{iHasProps})
    lst = 𝑇[]
    models((x) -> (x isa 𝑇) && 𝐹(x) && push!(lst, x), μ...)
    return lst
end

const NoGood = let leaf = Union{
        AbstractString, Number, Symbol, Color, MarkerType, Dates.AbstractTime,
        EnumType, Nothing, iNumeric, Missing
    }
    leaf = Union{leaf, Tuple{Vararg{leaf}}, NamedTuple{T, <:Tuple{Vararg{leaf}}} where {T}}
    Union{leaf, AbstractSet{<:leaf}, AbstractArray{<:leaf}, AbstractDict{<:leaf, <:leaf}}
end

"""
    bokehchildfields(T::Type{<:iHasProps})

Return the fields which *may* store `iHasProps` instances
"""
function bokehchildfields(@nospecialize(T::Type{<:iHasProps}))
    return (field for (field, p𝑇) ∈ bokehfields(T) if _👻hasbokehmodel(p𝑇))
end

"""
    bokehchildren([T::Type{<:iHasProps} = iHasProps], μ::iHasProps)

Return all `T` instances stored within the `μ` instance
"""
function bokehchildren(@nospecialize(T::Type{<:iHasProps}), @nospecialize(μ::iHasProps))
    return (j for i ∈ bokehchildfields(typeof(μ)) for j ∈ _👻children(getfield(μ, i)) if j isa T)
end

bokehchildren(@nospecialize(μ::iHasProps)) = bokehchildren(iHasProps, μ)

_👻hasbokehmodel(::Type) = true
_👻hasbokehmodel(::Type{<:NoGood}) = false
_👻hasbokehmodel(@nospecialize(𝑇::Type{<:ReadOnly})) = _👻hasbokehmodel(𝑇.parameters[1])

_👻children(::Any)    = ()
_👻children(::NoGood) = ()
_👻children(@nospecialize(mdl::iHasProps)) = (mdl,)
_👻children(@nospecialize(mdl::Union{Tuple, NamedTuple, AbstractSet{<:iHasProps}, AbstractArray{<:iHasProps}})) = mdl
_👻children(@nospecialize(mdl::AbstractDict{<:NoGood, <:iHasProps})) = values(mdl)
_👻children(@nospecialize(mdl::Tuple{<:iHasProps, Vararg{NoGood}})) = mdl[1:1]
_👻children(@nospecialize(mdl::AbstractDict{<:NoGood})) = (j for i ∈ values(mdl) for j ∈ _👻children(i))
_👻children(@nospecialize(mdl::Union{AbstractSet, AbstractArray})) = (j for i ∈ mdl for j ∈ _👻children(i))
_👻children(@nospecialize(mdl::iSpec)) = (mdl.item, mdl.transform)

const _𝑐𝑚𝑝_BIN = Union{Number, Symbol, Missing, Nothing, Function}

compare(::Any, ::Any)                    = false
compare(x::EnumType,  y::Symbol)         = x.value ≡ y
compare(x::Color,     y::AbstractString) = x ≡ color(y)
compare(x::iHasProps, y::iHasProps)      = x.id ≡ y.id
compare(x::_𝑐𝑚𝑝_BIN,  y::_𝑐𝑚𝑝_BIN)       = x ≡ y
compare(x::Pair, y::Pair)                = compare(first(x), first(y)) && compare(last(x), last(y))
compare(x::AbstractString, y::AbstractString) = x == y
compare(x::T, y::T) where {T} = (x ≡ y) ||  all(compare(getproperty(x, i), getproperty(y, i)) for i ∈ fieldnames(T))
compare(x::AbstractSet, y::AbstractSet) = (x ≡ y) || (length(x) ≡ length(y) && all(i ∈ y for i ∈ x))

for (cls, 𝐹) ∈ (AbstractArray => size, Tuple => length)
    @eval compare(x::$cls, y::$cls) = (x ≡ y) || ($𝐹(x) ≡ $𝐹(y) && all(compare(x[i], y[i]) for i ∈ eachindex(x)))
end

for cls ∈ (AbstractDict, NamedTuple)
    @eval function compare(x::$cls, y::$cls)
        isempty(x) && isempty(y) && return true
        x ≡ y && return true
        return length(x) ≡ length(y) && all(haskey(y, i) && compare(j, y[i]) for (i, j) ∈ pairs(x))
    end
end

function isdefaultvalue(η::𝑇, α::Symbol) where {𝑇 <: iHasProps}
    dflt  = defaultvalue(typeof(η), α)
    isnothing(dflt) && return false
    left  = bokehunwrap(getproperty(η, α))
    f𝑇    = bokehfieldtype(𝑇, α)
    right = bokehunwrap(bokehread(f𝑇, η, α, bokehconvert(f𝑇, something(dflt))))
    return compare(left, right)
end

export bokehids, bokehmodels, bokehchildren
