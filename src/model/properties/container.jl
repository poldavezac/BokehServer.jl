const CONTAINERS = Union{AbstractArray, AbstractDict, AbstractSet}

abstract type iContainer{T} <: iProperty end

struct Container{T, K} <: iContainer{T}
    parent::WeakRef
    attr  ::Symbol
    values::K
end

function bokehread(𝑇::Type{<:CONTAINERS}, µ::iHasProps, α::Symbol, ν::CONTAINERS)
    Container{𝑇, bokehfieldtype(𝑇)}(WeakRef(µ), α, ν)
end

bokehrawtype(ν::iContainer) = ν.values

# WARNING: we need explicit template args to make sure `bokehfieldtype(::Union)` will be called when needed
bokehfieldtype(𝑇::Type{<:AbstractDict{K, V}})  where {K, V} = 𝑇.name.wrapper{bokehfieldtype(K), bokehfieldtype(V)}
bokehfieldtype(𝑇::Type{<:AbstractSet{T}})      where {T}    = 𝑇.name.wrapper{bokehfieldtype(T)}
bokehfieldtype(𝑇::Type{<:AbstractArray{T, N}}) where {T, N} = 𝑇.name.wrapper{bokehfieldtype(T), N}

function bokehconvert(𝑇::Type{<:AbstractDict{𝐾, 𝑉}}, ν::AbstractDict) where {𝐾, 𝑉}
    params = 𝑇.parameters
    outp   = bokehfieldtype(𝑇)()
    for (i,j) ∈ ν
        iv = bokehconvert(𝐾, i)
        (iv isa Unknown) && return Unknown()

        jv = bokehconvert(𝑉, j)
        (jv isa Unknown) && return Unknown()

        push!(outp, iv => jv)
    end
    return outp
end

for cls ∈ (AbstractSet, AbstractVector)
    @eval function bokehconvert(𝑇::Type{<:$cls{𝐼}}, ν::$cls) where {𝐼}
        outp = bokehfieldtype(𝑇)()
        for i ∈ ν
            iv = bokehconvert(𝐼, i)
            (iv isa Unknown) && return Unknown()
            push!(outp, iv)
        end
        return outp
    end
end

bokehconvert(𝑇::Type{<:Pair}, ν::Pair) = bokehconvert(𝑇.parameters[1], first(ν)) => bokehconvert(𝑇.parameters[2], last(ν))

for (𝐹, (𝑇, code)) ∈ (
        :push!      => Container => :((bokehconvert(eltype(T), i) for i ∈ x)),
        :setindex!  => Container{<:AbstractDict}   => :((bokehconvert(eltype(T).parameters[2], x[1]), x[2])),
        :setindex!  => Container{<:AbstractArray}  => :((bokehconvert(eltype(T), x[1]), x[2:end]...)),
        :pop!       => Container => :x,
        :empty!     => Container => :x,
        :append!    => iContainer{<:AbstractArray} => :((bokehconvert(T, i) for i ∈ x)),
        :deleteat!  => iContainer{<:AbstractArray} => :x,
        :popat!     => iContainer{<:AbstractArray} => :x,
        :popfirst!  => iContainer{<:AbstractArray} => :x,
        :insert!    => iContainer{<:AbstractArray} => :((bokehconvert(eltype(T), i) for i ∈ x)),
        :delete!    => iContainer{<:Union{AbstractDict, AbstractSet}}  => :x,
        :merge!     => iContainer{<:AbstractDict} => :((bokehconvert(T, i) for i ∈ x)),
)
    @eval function Base.$𝐹(γ::T, x...; dotrigger::Bool = true) where {T <: $𝑇}
        parent = γ.parent.value
        if isnothing(parent) || getfield(parent, γ.attr) ≢ γ.values
            $𝐹(γ.values, $code...)
        else
            out = $𝐹(copy(γ.values), $code...)
            setproperty!(parent, γ.attr, out; dotrigger)
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

struct RestrictedKey{T} <: iProperty end

bokehfieldtype(::Type{<:RestrictedKey}) = Symbol
bokehconvert(𝑇::Type{<:RestrictedKey}, ν::AbstractString) = bokehconvert(𝑇, Symbol(ν))
function bokehconvert(::Type{RestrictedKey{T}}, ν::Symbol) where {T}
    (ν ∈ T) && throw(KeyError("Key $ν is not allowed"))
    return ν
end
