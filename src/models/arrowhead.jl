#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ArrowHead <: iArrowHead

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
