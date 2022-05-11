module Protocol
using ..Bokeh
using ..AbstractTypes
using ..Events
using ..Models
using ..Documents
using JSON

const Buffers = Vector{Pair{String, String}}

include("protocol/messages.jl")
include("protocol/serialize.jl")
include("protocol/patchdoc/send.jl")
include("protocol/patchdoc/receive.jl")
include("protocol/pushdoc.jl")
end
using .Protocol
