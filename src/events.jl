module Events
using DataStructures: OrderedDict
using ..AbstractTypes
using ..Models

abstract type iEventList end
abstract type iEvent end
abstract type iEventKey end
abstract type iRootEventKey <: iEventKey end

struct ModelChangedKey <: iEventKey
    model :: iModel
    attr  :: Symbol
end
Base.hash(key::ModelChangedKey) = hash((bokehid(key.model), key.attr))

struct ModelChangedEvent <: iEvent
    old :: Any
    new :: Any
end

for cls ∈ (:RootAddedKey, :RootRemovedKey)
    @eval begin
        struct $cls <: iRootEventKey
            doc  :: iDocument
            root :: iModel
        end
    end
end

const EventDict = OrderedDict{iEventKey, Union{iEvent, Nothing}}

struct EventList <: iEventList
    events :: EventDict
    EventList() = new(EventDict())
end

function trigger!(
        λ   :: EventList,
        μ   :: iModel,
        α   :: Symbol,
        old :: Any,
        new :: Any
)
    key = ModelChangedKey(μ, α)
    if key ∉ keys(λ.events)
        λ.events[key] = ModelChangedEvent(old, new)
    elseif λ.events[key].old ≡ new
        pop!(λ.events, key)
    else
        λ.events[key] = ModelChangedEvent(λ.events[key].old, new)
    end
end

function trigger!(λ::EventList, ::Type{RootAddedKey}, doc :: iDocument, root::iModel)
    λ.events[RootAddedKey(doc, root)] = nothing
end

function trigger!(λ::EventList, ::Type{RootRemovedKey}, doc :: iDocument, root::iModel)
    rem   = RootRemovedKey(doc, root)
    added = RootAddedKey(doc, root)
    if added ∈ keys(λ.events)
        pop!(λ.events, added)
    else
        λ.events[rem] = nothing
    end
end

function _flushevents!(::RootRemovedKey, ::Nothing)
    for cb ∈ key.doc.callbacks
        cb(key.doc, :RootRemoved, key.model)
    end
end

function _flushevents!(::RootAddedKey, ::Nothing)
    for cb ∈ key.doc.callbacks
        cb(key.doc, :RootAdded, key.model)
    end
end

function _flushevents!(key::ModelChangedKey, val::ModelChangedEvent)
    for cb ∈ getfield(getfield(key.model, :callbacks), key.attr)
        cb(key.model, key.attr, val.old, val.new)
    end
end

function flushevents!(λ::EventList)
    while !isempty(λ.events)
        _flushevents!(popfirst!(λ.events)...)
    end
end

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

eventlist(func::Function) = task_local_storage(func, :DOC_EVENTS, EventList())

function trigger(μ::iModel, args...)
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    trigger!(task_eventlist(), μ, args...)
end

function trigger(T::Type{<:iRootEventKey}, doc :: iDocument, roots::Vararg{iModel})
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    evts = task_eventlist()
    for root ∈ roots
        trigger!(evts, T, doc, root)
    end
end

module JSONWriter
    using JSON
    import JSON.Writer: show_json
    using ...AbstractTypes
    using ...Models
    using ..Events

    "Specifies module specific rules for json serialiation"
    struct Serialization <: JSON.Serializations.CommonSerialization
    end

    jsontype(mdl::T) where {T <: iModel} = (; type = nameof(T))

    function jsattributes(mdl::T) where {T <: iModel}
        return (;(
           i => getproperty(mdl, i)
           for i ∈ Models.bokehproperties(T; sorted = true)
           if let dflt = Models.defaultvalue(T, i)
               isnothing(dflt) || getproperty(mdl, i) ≢ something(dflt)
           end
        )...)
    end

    jsreference(μ::iModel) = (; attributes = jsattributes(μ), jsmodel(μ)..., jsontype(μ)...)
    jsmodel(μ::iModel)     = (; id = "$(bokehid(μ))")

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

    show_json(io::JSON.Writer.SC, s::Serialization, μ::iModel) = show_json(io, s, jsmodel(μ))

    function dojson(obj)
        sprint(obj) do io, itm
            show_json(io, Serialization(), itm)
        end
    end
end
using .JSONWriter

function json(λ::Events.EventList, doc::iDocument, oldids::Set{Int64})
    all = allmodels(doc)
    filt(k::ModelChangedKey) = bokehid(k.model) ∈ keys(all)
    filt(k::iRootEventKey)   = k.doc ≡ doc

    JSONWriter.dojson((;
        events     = [i for i ∈ λ.events if filt(first(i))],
        references = [JSONWriter.jsreference(j) for (i, j) ∈ all if i ∉ oldids]
    ))
end

export trigger
end

using .Events
