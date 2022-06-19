#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxSelectTool <: iBoxSelectTool

    syncable :: Bool = true

    origin :: Bokeh.Model.EnumType{(:corner, :center)} = :corner

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{Symbol}

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    select_every_mousemove :: Bool = false

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
