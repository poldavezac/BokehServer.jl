module Serialize
using  ..AbstractTypes
using  ...Models
using  ...Events

abstract type iRules end

"Specifies module specific rules for json serialiation"
struct Rules <: iRules end

serialtype(η::T, ::iRules) where {T <: iHasProps} = (; type = nameof(T))
serialtype(::Type{T}, ::iRules) where {T <: iHasProps} = (; type = nameof(T))

function serialattributes(η::T, 𝑅::iRules) where {T <: iHasProps}
    return (;(
        i => serialref(getproperty(η, i), 𝑅)
        for i ∈ Models.bokehproperties(T; sorted = true)
        if let dflt = Models.defaultvalue(T, i)
            isnothing(dflt) || getproperty(η, i) ≢ something(dflt)
        end
    )...)
end

serialroot(η::iHasProps, 𝑅::iRules) = (; attributes = serialattributes(η, 𝑅), serialref(η, 𝑅)..., serialtype(η, 𝑅)...)
serialroot(η::Events.iEvent, 𝑅::iRules) = serialref(η, 𝑅)
serialref(η::iHasProps,   ::iRules)  = (; id = "$(bokehid(η))")

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function serialref(η::$cls, 𝑅::iRules)
        return (;
            kind  = $(Meta.quot(Symbol(string(cls)[1:end-5]))),
            model = serialref(η.root, 𝑅)
        )
    end
end

function serialref(η::ModelChangedEvent, 𝑅::iRules)
    return (;
        attr  = η.attr,
        hint  = nothing,
        kind  = :ModelChanged,
        model = serialref(η.model, 𝑅),
        new   = serialref(η.new, 𝑅),
    )
end

serialref(η::Union{AbstractString, Number, Symbol}, ::iRules) = η
serialref(η::Union{AbstractVector, AbstractSet}, 𝑅::iRules) = [serialref(i, 𝑅) for i ∈ η]
serialref(η::AbstractDict, 𝑅::iRules) = Dict((serialref(i, 𝑅) => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(η::NamedTuple, 𝑅::iRules) = (; (i => serialref(j, 𝑅) for (i,j) ∈ η)...)
serialref(η::T, 𝑅::iRules) where {T} = (; (i => serialref(getproperty(η, i), 𝑅) for i ∈ propertynames(η))...)

const SERIAL_ROOTS = Union{Events.iEvent, iHasProps}
serialize(η::AbstractVector{<:SERIAL_ROOTS}, 𝑅 :: iRules = Rules()) = [serialroot(i, 𝑅) for i ∈ η]
serialize(η::SERIAL_ROOTS,                   𝑅 :: iRules = Rules()) = serialroot(η, 𝑅)

export serialize
end
using .Serialize
