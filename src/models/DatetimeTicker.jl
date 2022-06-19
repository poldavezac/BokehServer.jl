#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDatetimeTicker, Bokeh.Models.Ticker, Bokeh.Models.CustomJS

@model mutable struct DatetimeTicker <: iDatetimeTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    num_minor_ticks :: Int64 = 5

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tickers :: Vector{<:iTicker}

    tags :: Vector{Any}
end
