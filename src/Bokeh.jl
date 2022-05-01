module Bokeh
abstract type iModel end
abstract type iDocument end
include("models.jl")
include("events.jl")
include("document.jl")

end # module
