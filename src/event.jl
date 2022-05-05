module Events
using ..AbstractTypes
using ..Models
using DataStructures: OrderedDict

include("event/types.jl")
include("event/trigger.jl")
include("event/flush.jl")
include("event/send.jl")
include("event/receive.jl")

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

eventlist(func::Function) = task_local_storage(func, :DOC_EVENTS, EventList())

export trigger
end

using .Events
