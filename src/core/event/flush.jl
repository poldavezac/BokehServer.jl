eventcallbacks(key::iDocEvent) = key.doc.callbacks
eventcallbacks(key::iEvent)    = key.model.callbacks

flushevents!()                 = flushevents!(task_eventlist())
flushevents!(::NullEventList)  = iEvent[]

"""
    executecallbacks(evt::iEvent)

Calls callbacks linked to this event
"""
function executecallbacks(evt::iEvent)
    for cb ∈ eventcallbacks(evt)
        applicable(cb, evt) && cb(evt)
    end
end

"""
    flushevents!(λ::iEventList)

Calls callbacks for all events stored within the eventlist and all those
created during callbacks.

A list of all *processed* events is returned.
"""
function flushevents!(λ::iEventList)
    lst = iEvent[]
    while !isempty(λ)
        push!(lst, popfirst!(λ))
        executecallbacks(lst[end])
    end
    lst
end
