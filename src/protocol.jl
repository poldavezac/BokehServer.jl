module Protocol
using ..AbstractTypes
using ..Events
using ..Models
using JSON

const Buffers = Vector{Pair{String, String}}

include("protocol/messages.jl")
include("protocol/serialize.jl")
include("protocol/patchdoc/send.jl")
include("protocol/patchdoc/receive.jl")
end
using .Protocol
