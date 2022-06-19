#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct YearsTicker <: iYearsTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    interval :: Float64

    subscribed_events :: Vector{Symbol}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
