#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iBoxZoomTool, Bokeh.Models.CustomJS, Bokeh.Models.BoxAnnotation

@model mutable struct BoxZoomTool <: iBoxZoomTool

    syncable :: Bool = true

    origin :: Bokeh.Model.EnumType{(:corner, :center)} = :corner

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    match_aspect :: Bool = false

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
