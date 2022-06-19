#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iJitter, Bokeh.Models.CustomJS

@model mutable struct Jitter <: iJitter

    syncable :: Bool = true

    range :: Bokeh.Model.Nullable{<:iRange} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    mean :: Float64 = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    distribution :: Bokeh.Model.EnumType{(:normal, :uniform)} = :uniform

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    width :: Float64 = 1.0
end
