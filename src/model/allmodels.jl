for (name, tpe, checkkey, pushkey) ∈ (
    (:allmodels, Dict{Int64, iHasProps}, (x)->:(haskey(found, $x)), :(push!(found, bokehid(cur) => cur))),
    (:allids, Set{Int64}, (x) -> :($x ∈ found), :(push!(found, bokehid(cur))))
)
    @eval function $name(μ::Vararg{iHasProps}) :: $tpe
        found = $tpe()
        todos = collect(iHasProps, μ)
        while !isempty(todos)
            cur = pop!(todos)
            key = bokehid(cur)
            $(checkkey(:key)) && continue
            $pushkey

            for child ∈ allbokehchildren(cur)
                $(checkkey(:(bokehid(child)))) || push!(todos, child) 
            end
        end
        found
    end
end

function allbokehchildren(μ::T) where {T <: iHasProps}
    return Iterators.flatten(
        bokehchildren(bokehrawtype(getproperty(μ, field)))
        for field ∈ bokehproperties(T)
    )
end

const NoGood = Union{AbstractString, Number, Symbol}

bokehchildren(::Any) = ()
bokehchildren(mdl::iHasProps) = (mdl,)
bokehchildren(mdl::Union{AbstractSet{<:iHasProps}, AbstractArray{<:iHasProps}}) = mdl
bokehchildren(::Union{AbstractSet{<:NoGood}, AbstractArray{<:NoGood}, AbstractDict{<:NoGood, <:NoGood}}) = ()
bokehchildren(mdl::Union{AbstractSet, AbstractArray}) = Iterators.filter(Base.Fix2(isa, iHasProps), mdl)
bokehchildren(mdl::AbstractDict) = Iterators.filter(Base.Fix2(isa, iHasProps), Iterators.flatten(pairs(mdl)))

const _𝑐𝑚𝑝_BIN = Union{Number, Symbol, Missing, Nothing, Function}

compare(::Any, ::Any)               = false
compare(x::iHasProps, y::iHasProps) = x.id ≡ y.id
compare(x::_𝑐𝑚𝑝_BIN,  y::_𝑐𝑚𝑝_BIN)  = x ≡ y
compare(x::Pair, y::Pair)           = compare(first(x), first(y)) && compare(last(x), last(y))
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
        return length(x) ≡ length(y) && all(haskey(y, i) && compare(j, y[i]) for (i, j) ∈ x)
    end
end

function isdefaultvalue(η::iHasProps, α::Symbol)
    dflt = Model.defaultvalue(typeof(η), α)
    isnothing(dflt) && return false
    return compare(bokehrawtype(getproperty(η, α)), something(dflt))
end

export allids, allmodels, bokehchildren
