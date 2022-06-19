function bokehfieldtype(𝑇::Type{<:Tuple})
    @assert !any(T <: iContainer for T ∈ 𝑇.parameters)
    return 𝑇.name.wrapper{(bokehfieldtype(T) for T ∈ 𝑇.parameters)...}
end

function bokehconvert(𝑇::Type{<:Tuple}, ν::Union{Vector, Tuple})
    return tuple((bokehconvert(T, i) for (i, T) ∈ zip(ν, 𝑇.parameters))...)
end

function bokehread(𝑇::Type{<:Tuple}, μ::iHasProps, σ::Symbol, ν::Tuple)
    return tuple((bokehread(T, µ, σ, i) for (i, T) ∈ zip(ν, 𝑇.parameters))...)
end

bokehfieldtype(𝑇::Type{<:NamedTuple}) = 𝑇.name.wrapper{𝑇.parameters[1], bokehfieldtype(𝑇.parameters[2])}

_👻items(𝑇::Type{<:NamedTuple}) = zip(𝑇.parameters[1], 𝑇.parameters[2].parameters)

function bokehconvert(𝑇::Type{<:NamedTuple}, ν::NamedTuple)
    (length(fieldnames(𝑇) ∩ keys(ν)) ≡ length(fieldnames(𝑇))) || return Unknown()
    outp = (;(i => bokehconvert(T, ν[i]) for (i, T) ∈ _👻items(𝑇))...)
    return any(i isa Unknown for i ∈ outp) ? Unknown() : outp
end

function bokehconvert(𝑇::Type{<:NamedTuple}, ν::AbstractDict{<:AbstractString})
    return bokehconvert(𝑇, (; (Symbol(i) => j for (i, j) ∈ ν)...))
end

function bokehread(𝑇::Type{<:NamedTuple}, μ::iHasProps, σ::Symbol, ν::NamedTuple)
    return (; (i => bokehread(T, μ, σ, ν[i]) for (i, T) ∈ _👻items(𝑇))...)
end
