module Plotting
using ..AbstractTypes
using ..Documents
using ..Model
using ..Server
using ..Models
using ..Models: Plot
include("plotting/axis.jl")
include("plotting/tools.jl")
include("plotting/glyph.jl")
include("plotting/figure.jl")
include("plotting/serve.jl")
end
