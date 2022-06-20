#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct RangeTool <: iRangeTool

    description :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x_interaction :: Bool = true

    x_range :: Bokeh.Model.Nullable{iRange1d} = nothing

    y_interaction :: Bool = true

    y_range :: Bokeh.Model.Nullable{iRange1d} = nothing
end
