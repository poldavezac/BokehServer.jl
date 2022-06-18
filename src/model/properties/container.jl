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

bokehfieldtype(𝑇::AbstractDict) = 𝑇.name.wrapper{(T isa Type ? bokehfieldtype(T) : T for T ∈ 𝑇.parameters)...}
bokehfieldtype(𝑇::AbstractSet) = 𝑇.name.wrapper{(T isa Type ? bokehfieldtype(T) : T for T ∈ 𝑇.parameters)...}
bokehfieldtype(𝑇::AbstractArray) = 𝑇.name.wrapper{(T isa Type ? bokehfieldtype(T) : T for T ∈ 𝑇.parameters)...}

function bokehwrite(𝑇::Type{<:AbstractDict{𝐾, 𝑉}}, ν::AbstractDict) where {𝐾, 𝑉}
    params = 𝑇.parameters
    outp   = bokehfieldtype(𝑇)()
    for (i,j) ∈ ν
        iv = bokehwrite(𝐾, i)
        (iv isa Unknown) && return Unknown()

        jv = bokehwrite(𝑉, j)
        (jv isa Unknown) && return Unknown()

        push!(outp, iv => jv)
    end
    return outp
end

for cls ∈ (AbstractSet, AbstractVector)
    @eval function bokehwrite(𝑇::Type{<:$cls{𝐼}}, ν::$cls) where {𝐼}
        outp = bokehfieldtype(𝑇)()
        for i ∈ ν
            iv = bokehwrite(𝐼, i)
            (iv isa Unknown) && return Unknown()
            push!(outp, iv)
        end
        return outp
    end
end

bokehwrite(𝑇::Type{<:Pair}, ν::Pair) = bokehwrite(𝑇.parameters[1], first(ν)) => bokehwrite(𝑇.parameters[2], last(ν))

for (𝐹, (𝑇, code)) ∈ (
        :push!      => Container => :((bokehwrite(eltype(T), i) for i ∈ x)),
        :setindex!  => Container{<:AbstractDict}   => :((bokehwrite(eltype(T).parameters[2], x[1]), x[2])),
        :setindex!  => Container{<:AbstractArray}  => :((bokehwrite(eltype(T), x[1]), x[2:end]...)),
        :pop!       => Container => :x,
        :empty!     => Container => :x,
        :append!    => iContainer{<:AbstractArray} => :((bokehwrite(T, i) for i ∈ x)),
        :deleteat!  => iContainer{<:AbstractArray} => :x,
        :popat!     => iContainer{<:AbstractArray} => :x,
        :popfirst!  => iContainer{<:AbstractArray} => :x,
        :insert!    => iContainer{<:AbstractArray} => :((bokehwrite(eltype(T), i) for i ∈ x)),
        :delete!    => iContainer{<:Union{AbstractDict, AbstractSet}}  => :x,
        :merge!     => iContainer{<:AbstractDict} => :((bokehwrite(T, i) for i ∈ x)),
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
bokehwrite(𝑇::Type{<:RestrictedKey}, ν::AbstractString) = bokehwrite(𝑇, Symbol(ν))
function bokehwrite(::Type{RestrictedKey{T}}, ν::Symbol) where {T}
    (ν ∈ T) && throw(KeyError("Key $ν is not allowed"))
    return ν
end
