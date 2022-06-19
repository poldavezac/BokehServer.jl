#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCategoricalColorMapper, Bokeh.Models.CustomJS

@model mutable struct CategoricalColorMapper <: iCategoricalColorMapper

    syncable :: Bool = true

    start :: Int64 = 0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    name :: Bokeh.Model.Nullable{String} = nothing

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    palette :: Vector{Bokeh.Model.Color}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
