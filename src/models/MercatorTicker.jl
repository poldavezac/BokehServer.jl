#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iMercatorTicker, Bokeh.Models.CustomJS

@model mutable struct MercatorTicker <: iMercatorTicker

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    dimension :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:lat, :lon)}} = nothing

    desired_num_ticks :: Int64 = 6

    base :: Float64 = 10.0

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
