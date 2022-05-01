module Events
using JSON
using DataStructures: OrderedDict
using ..AbstractTypes
using ..Models

"Specifies module specific rules for json serialiation"
struct EventsSerialization <: JSON.Serializations.CommonSerialization
end

function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::iModel)
    JSON.Writer.show_json(io, s, (; id = modelid(itm)))
end

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

for cls ∈ (:RootAddedKey, :RootRemovedKey)
    @eval begin
        struct $cls <: iEventKey
            docid   :: Int64
            modelid :: Int64
        end

        $cls(doc::iDocument, root::iModel) = $cls(bokehid(doc), bokehid(root))

        function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::Pair{$cls, Nothing})
            JSON.Writer.show_json(
                io, s, 
                (
                    kind  = $(Meta.quot(Symbol(string(cls)[1:end-3]))),
                    model = (; itm = itm[1].model),
                )
            )
        end
    end
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
    key = ModelChangedKey(bokehid(μ), σ)
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

function trigger!(events:: EventList, key :: RootAddedKey, keys:: Vararg{RootAddedKey})
    for k ∈ (key, keys...)
        events.events[k] = nothing
    end
end

function trigger!(events:: EventList, key :: RootRemovedKey, keys :: Vararg{RootRemovedKey})
    for k ∈ (key, keys...)
        added = RootAddedKey(k.docid, key.modelid)
        if added ∈ keys(events.events)
            pop!(events.events, k)
        else
            events.events[k] = nothing
        end
    end
end

function trigger!(events::EventList) :: Dict{Int64, Dict{Symbol, Any}}
    changes = Dict{Int64, Dict{Symbol, Any}}()
    while !isempty(events.callbacks)
        (μ, σ, old, new) = popfirst!(events.callbacks)

        key = bokehid(μ)
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

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

function events!(func::Function)
    @assert !task_hasevents()
    task_local_storage(func, :DOC_EVENTS, EventList())
end

function trigger(μ :: Union{iDocument, iModel}, args...)
    @assert task_hasevents() "Doc is readonly in this task!"
    trigger!(task_local_storage(:DOC_EVENTS), μ, args...)
end

module References
    using ...AbstractTypes
    using ...Models

    type(mdl::T) where {T <: iModel} = (; type = nameof(T))

    function attributes(mdl::T) where {T <: iModel}
        return (;(
           i => getproperty(mdl, i)
           for i ∈ Models.bokehproperties(T; sorted = true)
           if let dflt = Models.defaultvalue(T, i)
               isnothing(dflt) || getproperty(mdl, i) ≢ something(dftl)
           end
        )...)
    end

    function namedtuple(itm::iModel) 
        return (;
            attributes = attributes(itm),
            id         = modelid(itm),
            referencetojson_type(itm)...
        )
    end
end

using .References

function json(events::Events.EventDict, doc::iDocument, oldids::Set{Int64})
    all = allmodels(doc)
    obj = (;
        events = let discarded = setdiff(oldids, keys(all))
            filter(events) do (key, value)
                if key isa ModelChangedEvent
                    key.id ∉ discarded
                elseif key isa Union{RootRemovedKey, RootAddedKey}
                    key.docid ≡ bokehid(doc)
                end
            end
        end,
        references = [
            References.namedtuple(all[i])
            for i ∈ setdiff(keys(all), oldids)
        ]
    )

    sprint(obj) do io, itm
        JSON.Writer.show_json(io, EventsSerialization(), itm)
    end
end
end

using .Events: trigger
