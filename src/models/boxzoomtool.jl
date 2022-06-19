#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxZoomTool <: iBoxZoomTool

    description :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    match_aspect :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    origin :: Bokeh.Model.EnumType{(:corner, :center)} = :corner

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
