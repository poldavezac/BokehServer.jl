#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDodge, Bokeh.Models.CustomJS

@model mutable struct Dodge <: iDodge

    syncable :: Bool = true

    value :: Float64 = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    range :: Bokeh.Model.Nullable{<:iRange} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
