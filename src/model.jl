module Model
using ..Bokeh
using ..AbstractTypes

include("model/properties.jl")
include("model/modelmacro.jl")
include("model/allmodels.jl")
end
using .Model
