module Send
    using JSON
    import JSON.Writer: show_json
    using ...AbstractTypes
    using ...Models
    using ..Events

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

    for cls ∈ (:RootAddedKey, :RootRemovedKey)
        @eval function show_json(
                io::JSON.Writer.SC,
                s::Serialization,
                itm::Pair{Events.$cls, Nothing}
        )
            show_json(
                io, s, 
                (
                    kind  = $(Meta.quot(Symbol(string(cls)[1:end-3]))),
                    model = jsmodel(first(itm).root)
                )
            )
        end
    end

    function show_json(
            io::JSON.Writer.SC,
            s::Serialization,
            itm::Pair{Events.ModelChangedKey, Events.ModelChangedEvent}
    )
        show_json(
            io, s, 
            (
                attr  = first(itm).attr,
                hint  = nothing,
                kind  = :ModelChanged,
                model = jsmodel(first(itm).model),
                new   = last(itm).new,
            )
        )
    end

    show_json(io::JSON.Writer.SC, s::Serialization, μ::iHasProps) = show_json(io, s, jsmodel(μ))

    function dojson(obj)
        sprint(obj) do io, itm
            show_json(io, Serialization(), itm)
        end
    end
end
using .Send

function json(λ::Events.EventList, doc::iDocument, oldids::Set{Int64})
    all = allmodels(doc)
    filt(k::ModelChangedKey) = bokehid(k.model) ∈ keys(all)
    filt(k::iRootEventKey)   = k.doc ≡ doc

    Send.dojson((;
        events     = [i for i ∈ λ.events if filt(first(i))],
        references = [Send.jsreference(j) for (i, j) ∈ all if i ∉ oldids]
    ))
end
