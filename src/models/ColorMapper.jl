#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iColorMapper, Bokeh.Models.CustomJS

@model mutable struct ColorMapper <: iColorMapper

    syncable :: Bool = true

    palette :: Vector{Bokeh.Model.Color}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    tags :: Vector{Any}
end
