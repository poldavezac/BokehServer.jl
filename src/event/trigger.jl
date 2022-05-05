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
