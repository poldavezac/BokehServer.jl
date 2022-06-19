#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iGroupingInfo, Bokeh.Models.RowAggregator, Bokeh.Models.CustomJS

@model mutable struct GroupingInfo <: iGroupingInfo

    syncable :: Bool = true

    aggregators :: Vector{<:iRowAggregator}

    name :: Bokeh.Model.Nullable{String} = nothing

    collapsed :: Bool = false

    subscribed_events :: Vector{Symbol}

    getter :: String = ""

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
