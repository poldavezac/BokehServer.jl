#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ZoomOutTool <: iZoomOutTool

    syncable :: Bool = true

    factor :: Bokeh.Model.Percent = 0.1

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    maintain_focus :: Bool = true

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
