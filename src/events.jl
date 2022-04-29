module Events
using ..Models

using DataStructures: OrderedDict
abstract type iEventList end

struct EventList <: iEventList
    callbacks:: OrderedDict{Tuple{Int64, Symbol}, Tuple}
end

function trigger!(
        events::EventList,
        μ     :: iModel,
        α     :: Symbol,
        old   :: Any,
        new   :: Any;
        force :: Bool = false
)
    key = (modelid(μ), σ)
    if key ∈ keys(events.callbacks)[key] 
        if first(events.callbacks[key]) == new
            pop!(events.callbacks, key)
        else
            events.callbacks[key] = first(events.callbacks[key]) => new
        end
    else
        events.callbacks[key] = old => new
    end

    push!(events, (μ, σ, old, new))
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
end

using .Events: trigger
