function trigger!(λ::iEventList, ε::ModelChangedEvent)
    old = pop!(λ, ε)
    if isnothing(old)
        push!(λ, ε)
    elseif old.old ≢ ε.new
        push!(λ, ModelChangedEvent(ε.model, ε.attr, old.old, ε.new))
    end
end

trigger!(λ::iEventList, ε::iDataSourceEvent) = push!(λ, ε)

for (cls, other) ∈ (x = (RootAddedEvent, RootRemovedEvent); (x, x[2:-1:1]))
    @eval function trigger!(λ::iEventList, ε::$cls)
        isnothing(pop!(λ, $other(ε.doc, ε.root, ε.index))) && push!(λ, ε)
    end
end

function trigger!(λ::iEventList, ε::TitleChangedEvent)
    pop!(λ, ε)
    push!(λ, ε)
end

trigger!(λ::Events.iEventList, ε::iActionEvent) = push!(λ, ε)

function trigger(args...)
    @assert task_hasevents() "No event list was set: doc is readonly in this task!"
    trigger!(task_eventlist(), args...)
end

function testcantrigger()
    isempty(task_hasevents()) || return
    throw(ErrorException(if isinteractive()
        """ No event list was set: doc is readonly in this task!
        In a `Pluto` or `Jupyter` environment, add a cell with the 
        following: `BokehJL.Embeddings.notebook()`
        """
    else
        "No event list was set: doc is readonly in this task!"
    end))
end

export trigger
