struct Container{T}
    parent::WeakRef
    attr  ::Symbol
    values::T
end

const CONTAINERS = Union{AbstractArray, AbstractDict, AbstractSet}
bokehread(::Type{T}, µ::iHasProps, α::Symbol, ν) where {T<:CONTAINERS}= Container{T}(WeakRef(µ), α, ν)
bokehrawtype(ν::Container) = ν.values

for (𝐹, 𝑇) ∈ (
        :push!      => Container,
        :pop!       => Container,
        :setindex!  => Container,
        :empty!     => Container,
        :append!    => Container{<:AbstractArray},
        :deleteat!  => Container{<:AbstractArray},
        :popat!     => Container{<:AbstractArray},
        :popfirst!  => Container{<:AbstractArray},
        :insert!    => Container{<:AbstractArray},
        :delete!    => Container{<:Union{AbstractDict, AbstractSet}},
        :get!       => Container{<:AbstractDict},
)
    @eval function Base.$𝐹(γ::T, x...; y...) where {T <: $𝑇}
        parent = γ.parent.value
        if isnothing(parent) || getfield(parent, γ.attr) ≢ γ
            $𝐹(γ.values, x...; y...)
        else
            old = copy(γ.values)
            out = $𝐹(γ.values, x...; y...)
            Events.trigger(Bokeh.ModelChangedEvent(parent, γ.attr, old, new))
            out ≡ γ.values ? γ : out
        end
    end
end

for (𝐹, 𝑇) ∈ (
        :length     => Container,
        :iterate    => Container,
        :getindex   => Container,
        :get        => Container{<:AbstractDict},
        :haskey     => Container{<:AbstractDict},
)
    @eval Base.$𝐹(γ::$𝑇, x...)  = $𝐹(γ.values, x...)
end

Base.in(ν, γ::Container) = in(ν, γ.values)
Base.eltype(::Type{<:Container{T}}) where {T}  = eltype(T)

const FactorSeq = Container{Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}}
