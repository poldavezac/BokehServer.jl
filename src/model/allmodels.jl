function allmodels(μ::Vararg{iModel}) :: Dict{Int64, iModel}
    found = Dict{Int64, iModel}()
    todos = collect(iModel, μ)
    while !isempty(todos)
        cur = pop!(todos)
        key = bokehid(cur)
        (key ∈ keys(found)) && continue
        found[bokehid(cur)] = cur

        for child ∈ children(cur)
            bokehid(child) ∈ keys(found) || push!(todos, child) 
        end
    end
    found
end

function children(μ::T) where {T <: iModel}
    return Iterators.flatten(_children(getproperty(μ, field)) for field ∈ bokehproperties(T))
end

_children(::Any) = ()
_children(mdl::iModel) = (mdl,)
_children(mdl::Union{Set{<:iModel}, AbstractArray{<:iModel}}) = mdl
_children(mdl::Union{AbstractSet, AbstractArray}) = (i for i ∈ mdl if i isa iModel)
_children(mdl::Dict) = (i for j ∈ mdl for i ∈ j if i isa iModel)

export allmodels, children
