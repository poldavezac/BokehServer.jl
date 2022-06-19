#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCategoricalMapper, Bokeh.Models.CustomJS

@model mutable struct CategoricalMapper <: iCategoricalMapper

    syncable :: Bool = true

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    start :: Int64 = 0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
