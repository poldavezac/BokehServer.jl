abstract type iContainer{T} end
struct Container{T} <: iContainer{T}
    parent::WeakRef
    attr  ::Symbol
    values::T
end

const CONTAINERS = Union{AbstractArray, AbstractDict, AbstractSet}
bokehread(𝑇::Type{<:iContainer}, µ::iHasProps, α::Symbol, ν) = 𝑇(WeakRef(µ), α, ν)
bokehrawtype(ν::iContainer) = ν.values
bokehfieldtype(::Type{<:iContainer{T}}) where {T} = T

for (𝐹, 𝑇) ∈ (
        :push!      => Container,
        :pop!       => Container,
        :setindex!  => Container,
        :empty!     => Container,
        :append!    => iContainer{<:AbstractArray},
        :deleteat!  => iContainer{<:AbstractArray},
        :popat!     => iContainer{<:AbstractArray},
        :popfirst!  => iContainer{<:AbstractArray},
        :insert!    => iContainer{<:AbstractArray},
        :delete!    => iContainer{<:Union{AbstractDict, AbstractSet}},
        :merge!     => iContainer{<:AbstractDict},
)
    @eval function Base.$𝐹(γ::T, x...; y...) where {T <: $𝑇}
        parent = γ.parent.value
        if isnothing(parent) || getfield(parent, γ.attr) ≢ γ.values
            $𝐹(γ.values, x...; y...)
        else
            old = copy(γ.values)
            out = $𝐹(γ.values, x...; y...)
            Bokeh.Events.trigger(Bokeh.Events.ModelChangedEvent(parent, γ.attr, old, out))
            out ≡ γ.values ? γ : out
        end
    end
end

Base.get!(γ::iContainer{<:AbstractDict}, x, y) = haskey(γ, x) ? γ[x] : (γ[x] = y; y)
Base.get!(𝐹::Function, γ::iContainer{<:AbstractDict}, x) = haskey(γ, x) ? γ[x] : (y = 𝐹(); γ[x] = y; y)

for (𝐹, 𝑇) ∈ (
        :length    => iContainer,
        :iterate   => iContainer,
        :getindex  => iContainer,
        :size      => iContainer{<:AbstractArray},
        :eachindex => iContainer{<:AbstractArray},
        :get       => iContainer{<:AbstractDict},
        :haskey    => iContainer{<:AbstractDict},
        :keys      => iContainer{<:AbstractDict},
        :values    => iContainer{<:AbstractDict},
)
    @eval Base.$𝐹(γ::$𝑇, x...)  = $𝐹(γ.values, x...)
end

Base.in(ν, γ::iContainer) = in(ν, γ.values)
Base.eltype(::Type{<:iContainer{T}}) where {T}  = eltype(T)

const FactorSeq = Container{Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}}
