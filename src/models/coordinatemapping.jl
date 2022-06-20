#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct CoordinateMapping <: iCoordinateMapping

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x_scale :: iScale = LinearScale()

    x_source :: iRange = DataRange1d()

    x_target :: iRange

    y_scale :: iScale = LinearScale()

    y_source :: iRange = DataRange1d()

    y_target :: iRange
end
