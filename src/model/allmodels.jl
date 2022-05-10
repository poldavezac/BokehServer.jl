function allmodels(μ::Vararg{iHasProps}) :: Dict{Int64, iHasProps}
    found = Dict{Int64, iHasProps}()
    todos = collect(iHasProps, μ)
    while !isempty(todos)
        cur = pop!(todos)
        key = bokehid(cur)
        (key ∈ keys(found)) && continue
        found[bokehid(cur)] = cur

        for child ∈ allbokehchildren(cur)
            bokehid(child) ∈ keys(found) || push!(todos, child) 
        end
    end
    found
end

function allbokehchildren(μ::T) where {T <: iHasProps}
    return Iterators.flatten(bokehchildren(getproperty(μ, field)) for field ∈ bokehproperties(T))
end

const NoGood = Union{AbstractString, Number, Symbol}

bokehchildren(::Any) = ()
bokehchildren(mdl::iHasProps) = (mdl,)
bokehchildren(mdl::Union{Set{<:iHasProps}, AbstractArray{<:iHasProps}}) = mdl
bokehchildren(::Union{Set{<:NoGood}, AbstractArray{<:NoGood}, Dict{<:NoGood, <:NoGood}}) = ()
bokehchildren(mdl::Union{AbstractSet, AbstractArray}) = (i for i ∈ mdl if i isa iHasProps)
bokehchildren(mdl::Dict) = (i for j ∈ mdl for i ∈ j if i isa iHasProps)

export allmodels, bokehchildren