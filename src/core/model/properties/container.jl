const CONTAINERS = Union{AbstractArray, AbstractDict, AbstractSet}

abstract type iContainer{T} <: iProperty end

struct Container{T, K} <: iContainer{T}
    parent::WeakRef
    attr  ::Symbol
    values::K
end

containertype(::Type{<:iContainer{T}}) where {T} = T

function bokehread(𝑇::Type{<:CONTAINERS}, µ::iHasProps, α::Symbol, ν::CONTAINERS)
    Container{𝑇, bokehstoragetype(𝑇)}(WeakRef(µ), α, ν)
end

bokehunwrap(ν::iContainer) = ν.values

# WARNING: we need explicit template args to make sure `bokehstoragetype(::Union)` will be called when needed
bokehstoragetype(𝑇::Type{<:AbstractDict{K, V}})  where {K, V} = 𝑇.name.wrapper{bokehstoragetype(K), bokehstoragetype(V)}
bokehstoragetype(𝑇::Type{<:AbstractSet{T}})      where {T}    = 𝑇.name.wrapper{bokehstoragetype(T)}
bokehstoragetype(𝑇::Type{<:AbstractArray{T, N}}) where {T, N} = 𝑇.name.wrapper{bokehstoragetype(T), N}

function bokehconvert(𝑇::Type{<:AbstractDict{𝐾, 𝑉}}, ν::AbstractDict) where {𝐾, 𝑉}
    params = 𝑇.parameters
    outp   = bokehstoragetype(𝑇)()
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
        outp = bokehstoragetype(𝑇)()
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
        :push!      => Container => :((bokehconvert(eltype(containertype(T)), i) for i ∈ x)),
        :setindex!  => Container{<:AbstractDict}   => :((bokehconvert(eltype(containertype(T)).parameters[2], x[1]), x[2])),
        :setindex!  => Container{<:AbstractArray}  => :((bokehconvert(eltype(containertype(T)), x[1]), x[2:end]...)),
        :pop!       => Container => :x,
        :empty!     => Container => :x,
        :append!    => iContainer{<:AbstractArray} => :((bokehconvert(containertype(T), i) for i ∈ x)),
        :deleteat!  => iContainer{<:AbstractArray} => :x,
        :popat!     => iContainer{<:AbstractArray} => :x,
        :popfirst!  => iContainer{<:AbstractArray} => :x,
        :insert!    => iContainer{<:AbstractArray} => :((bokehconvert(eltype(containertype(T)), i) for i ∈ x)),
        :delete!    => iContainer{<:Union{AbstractDict, AbstractSet}}  => :x,
        :merge!     => iContainer{<:AbstractDict} => :((bokehconvert(containertype(T), i) for i ∈ x)),
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

function Base.filter!(𝐹::Function, γ::Container; dotrigger::Bool = true)
    parent = γ.parent.value
    if isnothing(parent) || getfield(parent, γ.attr) ≢ γ.values
        filter!(𝐹, γ.values)
    else
        out = filter!(𝐹, copy(γ.values))
        setproperty!(parent, γ.attr, out; dotrigger)
        out ≡ γ.values ? γ : out
    end
end

Base.get!(γ::iContainer{<:AbstractDict}, x, y) = haskey(γ, x) ? γ[x] : (γ[x] = y; y)
Base.get!(𝐹::Function, γ::iContainer{<:AbstractDict}, x) = haskey(γ, x) ? γ[x] : (y = 𝐹(); γ[x] = y; y)

for (𝐹, 𝑇) ∈ (
        :length     => iContainer,
        :iterate    => iContainer,
        :size       => iContainer{<:AbstractArray},
        :eachindex  => iContainer{<:AbstractArray},
        :lastindex  => iContainer{<:AbstractArray},
        :firstindex => iContainer{<:AbstractArray},
        :get        => iContainer{<:AbstractDict},
        :haskey     => iContainer{<:AbstractDict},
        :keys       => iContainer{<:AbstractDict},
        :values     => iContainer{<:AbstractDict},
)
    @eval Base.$𝐹(γ::$𝑇, x...)  = $𝐹(γ.values, x...)
end

Base.getindex(γ::iContainer, x) = γ.values[x]
Base.getindex(γ::iContainer)    = γ.values[]

for 𝐹 ∈ (:in, :any, :all, :filter)
    @eval Base.$𝐹(ν, γ::iContainer) = $𝐹(ν, γ.values)
end
Base.eltype(::Type{<:iContainer{T}}) where {T}  = eltype(T)

struct RestrictedKey{T} <: iProperty end

bokehstoragetype(::Type{<:RestrictedKey}) = Symbol
bokehconvert(𝑇::Type{<:RestrictedKey}, ν::AbstractString) = bokehconvert(𝑇, Symbol(ν))
function bokehconvert(::Type{RestrictedKey{T}}, ν::Symbol) where {T}
    (ν ∈ T) && throw(KeyError("Key $ν is not allowed"))
    return ν
end
