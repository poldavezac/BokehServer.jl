#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iLegendItem, Bokeh.Models.GlyphRenderer, Bokeh.Models.CustomJS

@model mutable struct LegendItem <: iLegendItem

    syncable :: Bool = true

    label :: Bokeh.Model.Nullable{Bokeh.Model.Spec{String}} = nothing

    visible :: Bool = true

    renderers :: Vector{<:iGlyphRenderer}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    index :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
