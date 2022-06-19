#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DaysTicker <: iDaysTicker

    syncable :: Bool = true

    interval :: Float64

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    days :: Vector{Int64} = Int64[]

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
