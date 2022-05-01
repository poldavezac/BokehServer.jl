module Bokeh
abstract type iHasProps end
abstract type iModel        <: iHasProps end
abstract type iDataSource   <: iModel end
abstract type iSourcedModel <: iModel end
abstract type iDocument end

bokehid(μ::Union{iModel, iDocument}) = getfield(μ, :id)

include("models.jl")
include("events.jl")
include("document.jl")

end # module
