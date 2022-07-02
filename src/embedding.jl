module Embeddings
using ..AbstractTypes
using ..Server

include("embedding/standalone.jl")
include("embedding/notebook.jl")
end
