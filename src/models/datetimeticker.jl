#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatetimeTicker <: iDatetimeTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    tickers :: Vector{iTicker}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
