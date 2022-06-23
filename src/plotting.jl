module Plotting
using ...Model
using ...Models
using ...AbstractTypes
include("plotting/axis.jl")
include("plotting/tools.jl")
include("plotting/glyph.jl")
include("plotting/figure.jl")
end
using .Plotting: figure, glyph!
