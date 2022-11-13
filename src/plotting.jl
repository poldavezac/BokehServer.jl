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
include("plotting/layout.jl")
include("plotting/transform.jl")
include("plotting/stack.jl")
include("plotting/boxplot.jl")
include("plotting/hexbin.jl")
include("plotting/graph.jl")
include("plotting/html.jl")

using Requires

function __init__()
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" include(
        joinpath(@__DIR__, "plotting", "plots_backend.jl")
    )
end

end

using .Plotting
using .Plotting.Transforms
