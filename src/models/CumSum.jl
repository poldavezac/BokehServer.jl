#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCumSum, Bokeh.Models.CustomJS

@model mutable struct CumSum <: iCumSum

    syncable :: Bool = true

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    include_zero :: Bool = false

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
