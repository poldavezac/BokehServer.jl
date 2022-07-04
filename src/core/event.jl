module Events
using ..AbstractTypes
using ..Model
using DataStructures: OrderedDict

include("event/types.jl")
include("event/eventlist.jl")
include("event/trigger.jl")
include("event/flush.jl")
include("event/callbacks.jl")

const TASK_EVENTS = :BOKEH_EVENTS
"A global task list, to be used *sparringly* when we can't control task creation, say in Pluto notebooks"
const EVENTS      = Ref{Union{Nothing, iEventList}}(nothing)

task_hasevents() = !isnothing(EVENTS[]) || haskey(task_local_storage(), TASK_EVENTS)
task_eventlist() = get(task_local_storage(), TASK_EVENTS, EVENTS[])

function eventlist!(func::Function, λ = EventList(); flush :: Bool = true)
    task_local_storage(TASK_EVENTS, λ) do
        out = nothing
        try
            out = applicable(func) ? func() : func(λ)
        finally
            flush && (out = flushevents!(λ))
        end
        out
    end
end

export eventlist!
end

using .Events
