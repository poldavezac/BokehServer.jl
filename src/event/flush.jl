eventcallbacks(key::iDocEvent) = key.doc.callbacks
eventcallbacks(key::iEvent)         = key.model.callbacks

flushevents!()                = flushevents!(task_eventlist())
flushevents!(::NullEventList) = iEvent[]

function flushevents!(λ::iEventList)
    lst = iEvent[]
    while !isempty(λ)
        evt = popfirst!(λ)
        for cb ∈ eventcallbacks(evt)
            applicable(cb, evt) && cb(evt)
        end
        push!(lst, evt)
    end
    lst
end
