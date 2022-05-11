eventcallbacks(key::iDocumentEvent)    = key.doc.callbacks
eventcallbacks(key::ModelChangedEvent) = getfield(key.model, :callbacks)

function flushevents!(λ::iEventList = task_eventlist())
    lst = iEvent[]
    while !isempty(λ)
        evt = popfirst!(λ)
        for cb ∈ eventcallbacks(evt)
            cb(evt)
        end
        push!(lst, evt)
    end
    lst
end
