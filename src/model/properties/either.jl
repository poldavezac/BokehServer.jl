struct UnionIterator
    rem::Vector{Union}
    UnionIterator(𝑇::Union) = new(Union[𝑇])
end

Base.eltype(::Type{UnionIterator}) = Union{DataType, UnionAll}
Base.IteratorSize(::Type{UnionIterator}) = Base.SizeUnknown()
function Base.iterate(itr::UnionIterator, state = nothing)
    if state isa Union
        push!(itr.rem, state)
    elseif !isnothing(state)
        return (state, nothing)
    end
    
    while !isempty(itr.rem)
        T   = pop!(itr.rem)
        if T.b isa Union
            push!(itr.rem, T.b)
        else
            return (T.b, T.a)
        end

        if T.a isa Union
            push!(itr.rem, T.a)
        else
            return (T.a, nothing)
        end

    end
    return nothing
end

function bokehfieldtype(𝑇::Union)
    types = [bokehfieldtype(T) for T ∈ UnionIterator(𝑇)]
    for i ∈ 1:length(types)-1, j ∈ i+1:length(types)
        if types[i] <: types[j] || types[j] <: types[i]
            throw(ErrorException("`$𝑇` has non-orthogonal types $(types[i]) and $(types[j])"))
        end
    end
    return Union{types...}
end

function bokehwrite(𝑇::Union, ν)
    @nospecialize 𝑇 ν
    for T ∈ UnionIterator(𝑇)
        out = bokehwrite(T, ν)
        (out isa Unknown) || return out
    end

    throw(ErrorException("Can't write $ν as $𝑇"))
end

function bokehread(𝑇::Union, μ::iHasProps, σ::Symbol, ν)
    return first(
        bokehread(T, μ, σ, ν)
        for T ∈ UnionIterator(𝑇)
        if ν isa bokehfieldtype(T)
    )
end

const Factor    = Union{String, Tuple{String, String}, Tuple{String, String, String}}
const FactorSeq = Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}
