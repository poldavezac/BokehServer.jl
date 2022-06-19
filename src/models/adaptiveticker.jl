#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AdaptiveTicker <: iAdaptiveTicker

    base :: Float64 = 10.0

    desired_num_ticks :: Int64 = 6

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
