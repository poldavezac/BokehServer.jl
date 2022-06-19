#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iRangeTool, Bokeh.Models.CustomJS, Bokeh.Models.BoxAnnotation

@model mutable struct RangeTool <: iRangeTool

    syncable :: Bool = true

    y_range :: Bokeh.Model.Nullable{<:iRange1d} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    x_range :: Bokeh.Model.Nullable{<:iRange1d} = nothing

    y_interaction :: Bool = true

    tags :: Vector{Any}

    x_interaction :: Bool = true

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
