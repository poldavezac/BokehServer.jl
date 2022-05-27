struct Container{T}
    parent::WeakRef
    attr  ::Symbol
    values::T
end

const CONTAINERS = Union{AbstractArray, AbstractDict}
bokehread(::Type{T}, µ::iHasProps, α::Symbol, ν) where {T<:CONTAINERS}= Container{T}(WeakRef(µ), α, ν)
bokehrawtype(ν::Container) = ν.values

for (fcn, tpe) ∈ (
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
    @eval function Base.$fcn(v::T, x...; y...) where {T <: $tpe}
        parent = v.parent.value
        if isnothing(parent) || getfield(parent, v.attr) ≢ v
            $fcn(v.values, x...; y...)
        else
            old = copy(v.values)
            out = $fcn(v.values, x...; y...)
            Events.trigger(Bokeh.ModelChangedEvent(parent, v.attr, old, new))
            out ≡ v.values ? v : out
        end
    end
end

Base.getindex(v::Container, x...) = getindex(v.values, x...)
Base.get(v::Container{<:AbstractDict}, x...) = get(v.values, x...)

const FactorSeq = Container{Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}}
