module Events
using ..AbstractTypes
using ..Models
using DataStructures: OrderedDict

include("event/types.jl")
include("event/eventlist.jl")
include("event/trigger.jl")
include("event/flush.jl")
include("event/send.jl")
include("event/receive.jl")
include("event/callbacks.jl")

task_hasevents() = :DOC_EVENTS ∈ keys(task_local_storage())
task_eventlist() = task_local_storage(:DOC_EVENTS)

eventlist(func::Function, λ = EventList()) = task_local_storage(func, :DOC_EVENTS, λ)
end

using .Events
