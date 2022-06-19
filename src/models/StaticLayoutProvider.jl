#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStaticLayoutProvider, Bokeh.Models.CustomJS

@model mutable struct StaticLayoutProvider <: iStaticLayoutProvider

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    graph_layout :: Dict{Union{Int64, String}, Vector{Any}}
end
