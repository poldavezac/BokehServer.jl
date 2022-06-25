module Plotting
using ...Documents
using ...Model
using ...Models
using ...AbstractTypes
using ...Server: serve
include("plotting/axis.jl")
include("plotting/tools.jl")
include("plotting/glyph.jl")
include("plotting/figure.jl")
end
using .Plotting: figure, glyph!
