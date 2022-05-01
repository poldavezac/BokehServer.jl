module Events
using ..Bokeh: iDocument
using ..Models

using DataStructures: OrderedDict
abstract type iEventList end
abstract type iEvent end
abstract type iEventKey end

struct ModelChangedKey <: iEventKey
    id   :: Int64
    attr :: Int64
end

struct ModelChangedEvent <: iEvent
    old :: Any
    new :: Any
end

struct RootAddedKey <: iEventKey
    docid   :: Int64
    modelid :: Int64
end

struct RootRemovedKey <: iEventKey
    docid   :: Int64
    modelid :: Int64
end

const EventDict = OrderedDict{iEventKey, iEvent}

struct EventList <: iEventList
    events:: OrderedDict{iEventKey, Union{iEvent, Nothing}}
end

function trigger!(
        events:: EventList,
        μ     :: iModel,
        α     :: Symbol,
        old   :: Any,
        new   :: Any
)
    key = ModelChangedKey(Models.modelid(μ), σ)
    if key ∈ keys(events.events)
        if events.events[key].old == new
            pop!(events.events, key)
        else
            events.events[key] = ModelChangedEvent(events.events[key].old, new)
        end
    else
        events.events[key] = ModelChangedEvent(old, new)
    end
end

function trigger!(events:: EventList, key :: RootAddedKey)
    events.events[key] = nothing
end

function trigger!(events:: EventList, key :: RootRemovedKey)
    added = RootAddedKey(key.docid, key.modelid)
    if added ∈ keys(events.events)
        pop!(events.events, key)
    else
        events.events[key] = nothing
    end
end

function trigger!(events::EventList) :: Dict{Int64, Dict{Symbol, Any}}
    changes = Dict{Int64, Dict{Symbol, Any}}()
    while !isempty(events.callbacks)
        (μ, σ, old, new) = popfirst!(events.callbacks)

        key = Models.modelid(μ)
        if key ∈ changes
            changes[key][σ] = new
        else
            changes[key] = Dict{Symbol, Any}(σ => new)
        end

        for cb ∈ getfield(getfield(μ, :callbacks), σ)
            cb(μ, σ, old, new)
        end
    end

    return changes
end

hasevents() = :DOC_EVENTS ∈ task_local_storage()

task_eventlist() = task_local_storage(:DOC_EVENTS)

function events!(func::Function)
    @assert !hasevents()
    task_local_storage(func, :DOC_EVENTS, EventList())
end

function trigger(μ :: iModel, args...; force :: Bool = false)
    @assert :DOC_EVENTS ∈ task_local_storage() "Doc is readonly in this task!"
    Events.trigger!(task_local_storage(:DOC_EVENTS), μ, args...; force)
end

using JSON

struct EventsSerialization <: JSON.Serializations.CommonSerialization
end

function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::iModel)
    JSON.Writer.show_json(io, s, (; id = modelid(itm)))
end

function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::Pair{ModelChangedKey, ModelChangedEvent})
    JSON.Writer.show_json(
        io, s, 
        (
            kind  = :ModelChanged,
            model = (; id = itm[1].id),
            attr  = itm[1].attr,
            new   = item[2].new,
            hint  = nothing
        )
    )
end

for cls ∈ (RootAddedKey, RootRemovedKey)
    @eval function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::Pair{$cls, Nothing})
        JSON.Writer.show_json(
            io, s, 
            (
                kind  = $(Meta.quot(Symbol(string(nameof(cls))[1:end-3]))),
                model = (; itm = itm[1].model),
            )
        )
    end
end


function referencetojson_type(mdl::T) where {T <: iModel}
    return (; type = nameof(T))
end

function referencetojson_attributes(mdl::T) where {T <: iModel}
    dflt = T()
    return (;(
       i => getproperty(mdl, i)
       for i ∈ Models.bokehproperties(T; sorted = true)
       if getproperty(mdl, i) ≢ getproperty(dflt, i)
    )...)
end

function referencetojson(itm::iModel) 
    return (;
        attributes = referencetojson_attributes(itm),
        id         = modelid(itm),
        referencetojson_type(itm)...
    )
end

function json(events::Events.EventDict, doc::Document, oldids::Set{Int64})
    all = allmodels(doc)
    obj = (;
        events = let discarded = setdiff(oldids, keys(all))
            filter(events) do (key, value)
                if key isa ModelChangedEvent
                    key.id ∉ discarded
                elseif key isa Union{RootRemovedKey, RootAddedKey}
                    key.docid ≡ Models.modelid(doc)
                end
            end
        end,
        references = [
            referencetojson(all[i])
            for i ∈ setdiff(keys(all), oldids)
        ]
    )

    sprint(obj) do io, itm
        JSON.Writer.show_json(io, EventsSerialization(), itm)
    end
end
end

using .Events: trigger
