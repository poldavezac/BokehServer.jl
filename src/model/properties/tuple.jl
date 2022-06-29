for i = 1:24 # we need specific implementations per tuple size. Otherwise `bokehstoragetype(::Union)` doesn't get called
    let 𝑇s = tuple((Symbol("T$j") for j ∈ 1:i)...)
        @eval function bokehstoragetype(::Type{Tuple{$(𝑇s...)}}) where {$(𝑇s...)}
            return Tuple{$((:(bokehstoragetype($𝑉)) for 𝑉 ∈ 𝑇s)...)}
        end

        @eval function bokehconvert(::Type{Tuple{$(𝑇s...)}}, ν::Union{Vector, Tuple}) where {$(𝑇s...)}
            return tuple($((:(bokehconvert($𝑉, ν[$j])) for (j, 𝑉) ∈ enumerate(𝑇s))...))
        end

        @eval function bokehread(::Type{Tuple{$(𝑇s...)}}, μ::iHasProps, σ::Symbol, ν::Tuple) where {$(𝑇s...)}
            return tuple($((:(bokehread($𝑉, μ, σ, ν[$j])) for (j, 𝑉) ∈ enumerate(𝑇s))...))
        end
    end
end

bokehstoragetype(::Type{NamedTuple{K, V}}) where {K, V} = NamedTuple{K, bokehstoragetype(V)}

function bokehconvert(::Type{NamedTuple{K, V}}, ν::NamedTuple) where {K, V}
    ((length(keys(ν)) ≡ length(K)) && all(k ∈ K for k ∈ keys(ν))) || return Unknown()
    outp = (;(i => bokehconvert(T, ν[i]) for (i, T) ∈ zip(K, V.parameters))...)
    return any(i isa Unknown for i ∈ outp) ? Unknown() : outp
end

function bokehconvert(𝑇::Type{NamedTuple{K, V}}, ν::AbstractDict) where {K, V}
    (length(keys(ν)) ≡ length(K)) || return Unknown()
    return bokehconvert(𝑇, (; (Symbol(i) => j for (i, j) ∈ ν)...))
end

function bokehread(::Type{NamedTuple{K, V}}, μ::iHasProps, σ::Symbol, ν::NamedTuple{K}) where {K, V}
    return (; (i => bokehread(T, μ, σ, ν[i]) for (i, T) ∈ zip(K, V.parameters))...)
end
