module ToJSON
using  JSON
import JSON.Writer: show_json
using  ..AbstractTypes
using  ...Models
using  ...Events

"Specifies module specific rules for json serialiation"
struct Serialization <: JSON.Serializations.CommonSerialization
end

jsontype(mdl::T) where {T <: iHasProps} = (; type = nameof(T))
jsontype(::Type{T}) where {T <: iHasProps} = (; type = nameof(T))

function jsattributes(mdl::T) where {T <: iHasProps}
    return (;(
       i => getproperty(mdl, i)
       for i ∈ Models.bokehproperties(T; sorted = true)
       if let dflt = Models.defaultvalue(T, i)
           isnothing(dflt) || getproperty(mdl, i) ≢ something(dflt)
       end
    )...)
end

jsreference(μ::iHasProps) = (; attributes = jsattributes(μ), jsmodel(μ)..., jsontype(μ)...)
jsmodel(μ::iHasProps)     = (; id = "$(bokehid(μ))")

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function show_json(
            io::JSON.Writer.SC,
            s::Serialization,
            itm::$cls
    )
        show_json(
            io, s, 
            (
                kind  = $(Meta.quot(Symbol(string(cls)[1:end-5]))),
                model = jsmodel(itm.root)
            )
        )
    end
end

function show_json(
        io::JSON.Writer.SC,
        s::Serialization,
        itm::ModelChangedEvent
)
    show_json(
        io, s, 
        (
            attr  = itm.attr,
            hint  = nothing,
            kind  = :ModelChanged,
            model = jsmodel(itm.model),
            new   = itm.new,
        )
    )
end

show_json(io::JSON.Writer.SC, s::Serialization, μ::iHasProps) = show_json(io, s, jsmodel(μ))

function sprintjson(obj)
    sprint(obj) do io, itm
        show_json(io, Serialization(), itm)
    end
end
end
using .ToJSON

