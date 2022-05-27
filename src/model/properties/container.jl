struct Container{T}
    parent::WeakRef
    attr  ::Symbol
    values::T
end

const CONTAINERS = Union{AbstractArray, AbstractDict}
bokehread(::Type{T}, µ::iHasProps, α::Symbol, ν) where {T<:CONTAINERS}= Container{T}(WeakRef(µ), α, ν)
bokehrawtype(ν::Container) = ν.values

for (𝐹, tpe) ∈ (
        :push!      => Container,
        :pop!       => Container,
        :setindex!  => Container,
        :append!    => Container{<:AbstractArray},
        :deleteat!  => Container{<:AbstractArray},
        :popat!     => Container{<:AbstractArray},
        :popfirst!  => Container{<:AbstractArray},
        :insert!    => Container{<:AbstractArray},
        :delete!    => Container{<:AbstractDict},
        :pop!       => Container{<:AbstractDict},
        :get!       => Container{<:AbstractDict},
)
    @eval function Base.$𝐹(v::T, x...; y...) where {T <: $tpe}
        parent = v.parent.value
        if isnothing(parent) || getfield(parent, v.attr) ≢ v
            $𝐹(v.values, x...; y...)
        else
            old = copy(v.values)
            out = $𝐹(v.values, x...; y...)
            Events.trigger(Bokeh.ModelChangedEvent(parent, v.attr, old, new))
            out ≡ v.values ? v : out
        end
    end
end

Base.eltype(::Type{Container{T}}) where {T}  = eltype(T)
for 𝐹 ∈ (:length, :iterate, :getindex)
    @eval Base.$𝐹(v::Container, x...)  = $𝐹(v.values, x...)
end
Base.get(v::Container{<:AbstractDict}, x...) = get(v.values, x...)

const FactorSeq = Container{Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}}
