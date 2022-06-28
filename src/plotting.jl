module Plotting
using ...Documents
using ...Model
using ...Models
using ...Models: Plot
using ...AbstractTypes
using ...Server
include("plotting/axis.jl")
include("plotting/tools.jl")
include("plotting/glyph.jl")
include("plotting/figure.jl")
include("plotting/serve.jl")
end
