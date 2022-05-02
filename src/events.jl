module Events
using JSON
using DataStructures: OrderedDict
using ..AbstractTypes
using ..Models

"Specifies module specific rules for json serialiation"
struct EventsSerialization <: JSON.Serializations.CommonSerialization
end

function JSON.Writer.show_json(io::JSON.Writer.SC, s::EventsSerialization, itm::iModel)
    JSON.Writer.show_json(io, s, (; id = bokehid(itm)))
end

abstract type iEventList end
abstract type iEvent end
abstract type iEventKey end

struct ModelChangedKey <: iEventKey
    model :: iModel
    attr  :: Symbol
end
Base.hash(key::ModelChangedKey) = hash((bokehid(key.model), key.attr))

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
            docid  :: Int64
            rootid :: Int64
            $cls(doc::iDocument, root::iModel) = new(bokehid(doc), bokehid(root))
        end


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

function _flushevents!(::Dict{Int64, Dict{Symbol, Any}}, ::Union{RootRemovedKey, RootAddedKey}, ::Nothing) end

function _flushevents!(changes::Dict{Int64, Dict{Symbol, Any}}, key::ModelChangedKey, val::ModelChangedEvent)
    get!(Dict{Symbol, Any}, changes, bokehid(key.model))[key.attr] = val.new
    for cb ∈ getfield(getfield(key.model, :callbacks), key.attr)
        cb(key.model, key.attr, val.old, val.new)
    end
end

function flushevents!(λ::EventList) :: Dict{Int64, Dict{Symbol, Any}}
    changes = Dict{Int64, Dict{Symbol, Any}}()
    while !isempty(λ.events)
        _flushevents!(changes, popfirst!(λ.events)...)
    end

    return changes
end

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

eventlist(func::Function) = task_local_storage(func, :DOC_EVENTS, EventList())

function trigger(μ::iModel, args...)
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    trigger!(task_eventlist(), μ, args...)
end

function trigger(T::Type{<:Union{RootAddedKey, RootRemovedKey}}, doc :: iDocument, roots::Vararg{iModel})
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    evts = task_eventlist()
    for root ∈ roots
        trigger!(evts, T, doc, root)
    end
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
            id         = bokehid(itm),
            referencetojson_type(itm)...
        )
    end
end

using .References

function json(λ::Events.EventList, doc::iDocument, oldids::Set{Int64})
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

export trigger
end

using .Events
