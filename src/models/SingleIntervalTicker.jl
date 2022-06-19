#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iSingleIntervalTicker, Bokeh.Models.CustomJS

@model mutable struct SingleIntervalTicker <: iSingleIntervalTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    desired_num_ticks :: Int64 = 6

    interval :: Float64

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    num_minor_ticks :: Int64 = 5
end
