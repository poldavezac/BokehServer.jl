#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct ZoomInTool <: iZoomInTool

    description :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    factor :: Bokeh.Model.Percent = 0.1

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
