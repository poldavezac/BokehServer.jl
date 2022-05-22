module Events
using ..AbstractTypes
using ..Models
using DataStructures: OrderedDict

include("event/types.jl")
include("event/eventlist.jl")
include("event/trigger.jl")
include("event/flush.jl")
include("event/callbacks.jl")

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

function eventlist(func::Function, λ = EventList(); flush :: Bool = true)
    task_local_storage(:DOC_EVENTS, λ) do
        out = nothing
        try
            out = func()
        finally
            flush && (out = flushevents!(λ))
        end
        out
    end
end
end

using .Events
