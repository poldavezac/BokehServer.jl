#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct WheelZoomTool <: iWheelZoomTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    maintain_focus :: Bool = true

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    speed :: Float64 = 0.0016666666666666668

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    zoom_on_axis :: Bool = true
end
