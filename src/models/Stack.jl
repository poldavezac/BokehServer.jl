#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStack, Bokeh.Models.CustomJS

@model mutable struct Stack <: iStack

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    fields :: Vector{String} = String[]

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
