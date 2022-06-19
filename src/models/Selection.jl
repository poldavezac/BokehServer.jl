#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iSelection, Bokeh.Models.CustomJS

@model mutable struct Selection <: iSelection

    syncable :: Bool = true

    multiline_indices :: Dict{String, Vector{Int64}}

    indices :: Vector{Int64} = Int64[]

    name :: Bokeh.Model.Nullable{String} = nothing

    line_indices :: Vector{Int64} = Int64[]

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
