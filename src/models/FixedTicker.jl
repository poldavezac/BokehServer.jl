#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iFixedTicker, Bokeh.Models.CustomJS

@model mutable struct FixedTicker <: iFixedTicker

    syncable :: Bool = true

    ticks :: Vector{Float64} = Float64[]

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    minor_ticks :: Vector{Float64} = Float64[]

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
