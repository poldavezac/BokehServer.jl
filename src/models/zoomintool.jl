#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ZoomInTool <: iZoomInTool

    syncable :: Bool = true

    factor :: Bokeh.Model.Percent = 0.1

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
