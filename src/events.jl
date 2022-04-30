module Events
using ..Models

using DataStructures: OrderedDict
abstract type iEventList end
abstract type iEvent end

struct EventKey
    id   :: Int64
    attr :: Int64
end

struct ModelChangedEvent <: iEvent
    old :: Any
    new :: Any
end

const EventDict = OrderedDict{EventKey, iEvent}

struct EventList <: iEventList
    callbacks:: OrderedDict{EventKey, iEvent}
end

function trigger!(
        events:: EventList,
        μ     :: iModel,
        α     :: Symbol,
        old   :: Any,
        new   :: Any;
        force :: Bool = false
)
    key = EventKey(modelid(μ), σ)
    if key ∈ keys(events.callbacks)
        if events.callbacks[key].old == new
            pop!(events.callbacks, key)
        else
            events.callbacks[key] = ModelChangedEvent(events.callbacks[key].old, new)
        end
    else
        events.callbacks[key] = ModelChangedEvent(old, new)
    end
end

function trigger!(events::EventList) :: Dict{Int64, Dict{Symbol, Any}}
    changes = Dict{Int64, Dict{Symbol, Any}}()
    while !isempty(events.callbacks)
        (μ, σ, old, new) = popfirst!(events.callbacks)

        key = modelid(μ)
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

function events!(func::Function)
    @assert !hasevents()
    task_local_storage(func, :DOC_EVENTS, EventList())
end

function trigger(μ :: iModel, args...; force :: Bool = false)
    @assert :DOC_EVENTS ∈ task_local_storage() "Doc is readonly in this task!"
    Events.trigger!(task_local_storage(:DOC_EVENTS), μ, args...; force)
end


abstract type iEventInfo end

struct Ref
    id :: Int64
end

struct ModelChanged <: iEventInfo
    model :: Ref
    attr  :: Symbol
    new   :: Any
end

propertynames(itm::T) where {T <: iEventInfo} = (:kind, :hint, fieldnames(T)...)

function getproperty(itm::T, attr::Symbol) where {T <: iEventInfo}
    if attr ≡ :kind
        return nameof(T)
    elseif attr ≡ :hint
        return nothing
    else
        return getfiedl(itm, attr)
    end
end

function tojsonlike(itm::Tuple{EventKey, ModelChangedEvent}) :: ModelChanged
    return ModelChanged(Ref(itm[1].model), itm[1].attr, item[2].new)
end
end

using .Events: trigger
