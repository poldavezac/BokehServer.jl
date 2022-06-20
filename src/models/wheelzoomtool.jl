#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct WheelZoomTool <: iWheelZoomTool

    description :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    maintain_focus :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    speed :: Float64 = 0.0016666666666666668

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    zoom_on_axis :: Bool = true
end
