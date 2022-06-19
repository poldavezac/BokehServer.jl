#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iMapOptions, Bokeh.Models.CustomJS

@model mutable struct MapOptions <: iMapOptions

    syncable :: Bool = true

    lng :: Float64

    name :: Bokeh.Model.Nullable{String} = nothing

    lat :: Float64

    subscribed_events :: Vector{Symbol}

    zoom :: Int64 = 12

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
