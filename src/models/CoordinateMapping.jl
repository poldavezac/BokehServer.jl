#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCoordinateMapping, Bokeh.Models.Range, Bokeh.Models.Scale, Bokeh.Models.CustomJS

@model mutable struct CoordinateMapping <: iCoordinateMapping

    syncable :: Bool = true

    x_target :: iRange

    y_scale :: iScale = LinearScale()

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    y_source :: iRange = DataRange1d()

    y_target :: iRange

    name :: Bokeh.Model.Nullable{String} = nothing

    x_source :: iRange = DataRange1d()

    x_scale :: iScale = LinearScale()

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
