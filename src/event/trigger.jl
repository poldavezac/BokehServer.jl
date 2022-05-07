function trigger!(λ :: EventList, ε::ModelChangedEvent)
    old = pop!(λ, ε)
    if isnothing(old)
        push!(λ, ε)
    elseif old.old ≢ ε.new
        push!(λ, ModelChangedEvent(ε.model, ε.attr, old.old, ε.new))
    end
end

for cls ∈ (:RootAddedEvent, :RootRemovedEvent)
    @eval function trigger!(λ::EventList, ε::$cls)
        other = $(cls ≡ :RootAddedEvent ? RootRemovedEvent : RootAddedEvent)(ε.doc, ε.root)
        isnothing(pop!(λ, other)) && push!(λ, ε)
    end
end

function trigger(args...)
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    trigger!(task_eventlist(), args...)
end

export trigger
