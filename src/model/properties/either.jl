struct Either{T} <: iProperty end

bokehfieldtype(𝑇::Type{<:Either}) = Tuple{Union{(bokehfieldtype(T) for T ∈ 𝑇.parameters[1].parameters)...}, UInt8}

function bokehwrite(𝑇::Type{<:Either}, ν)
    @nospecialize 𝑇 ν
    for (i, T) ∈ enumerate(𝑇.parameters[1].parameters)
        (typeof(ν) <: bokehfieldtype(T)) && return (bokehwrite(T, ν), UInt8(i))
    end

    for (i, T) ∈ enumerate(𝑇.parameters[1].parameters)
        out = bokehwrite(T, ν)
        (out isa Unknown) || return (out, UInt8(i))
    end

    throw(ErrorException("Can't write $ν as $𝑇"))
end

function bokehread(𝑇::Type{<:Either}, μ::iHasProps, σ::Symbol, ν::Tuple{<:Any, UInt8})
    return bokehread(𝑇.parameters[1].parameters[Int64(ν[2])], μ, σ, ν[1])
end
