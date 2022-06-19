#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iBooleanFilter, Bokeh.Models.CustomJS

@model mutable struct BooleanFilter <: iBooleanFilter

    syncable :: Bool = true

    booleans :: Bokeh.Model.Nullable{Vector{Bool}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
