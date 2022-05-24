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
    return Iterators.flatten(bokehchildren(getproperty(μ, field)) for field ∈ bokehproperties(T))
end

const NoGood = Union{AbstractString, Number, Symbol}

bokehchildren(::Any) = ()
bokehchildren(mdl::iHasProps) = (mdl,)
bokehchildren(mdl::Union{Set{<:iHasProps}, AbstractArray{<:iHasProps}}) = mdl
bokehchildren(::Union{Set{<:NoGood}, AbstractArray{<:NoGood}, Dict{<:NoGood, <:NoGood}}) = ()
bokehchildren(mdl::Union{AbstractSet, AbstractArray}) = (i for i ∈ mdl if i isa iHasProps)
bokehchildren(mdl::Dict) = (i for j ∈ mdl for i ∈ j if i isa iHasProps)

export allids, allmodels, bokehchildren
