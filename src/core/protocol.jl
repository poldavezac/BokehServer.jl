module Protocol
using ..AbstractTypes
using ..Events
using ..Model
using ..Documents
using JSON
const PROTOCOL_VERSION = v"3.0.2"

const Buffers = Vector{Pair{String, Vector{UInt8}}}

include("protocol/messages.jl")
include("protocol/serialization.jl")
include("protocol/patchdoc.jl")
include("protocol/pushdoc.jl")
end

using .Protocol
