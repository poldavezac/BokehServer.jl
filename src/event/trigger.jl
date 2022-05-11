function trigger!(λ :: EventList, ε::ModelChangedEvent)
    old = pop!(λ, ε)
    if isnothing(old)
        push!(λ, ε)
    elseif old.old ≢ ε.new
        push!(λ, ModelChangedEvent(ε.model, ε.attr, old.old, ε.new))
    end
end

for (cls, other) ∈ (x = (RootAddedEvent, RootRemovedEvent); (x, x[2:-1:1]))
    @eval function trigger!(λ::EventList, ε::$cls)
        isnothing(pop!(λ, $other(ε.doc, ε.root, ε.index))) && push!(λ, ε)
    end
end

function trigger!(λ::EventList, ε::TitleChangedEvent)
    pop!(λ, ε)
    push!(λ, ε)
end

function trigger(args...)
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    trigger!(task_eventlist(), args...)
end

export trigger
