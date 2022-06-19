#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LegendItem <: iLegendItem

    syncable :: Bool = true

    visible :: Bool = true

    label :: Bokeh.Model.Nullable{Bokeh.Model.Spec{String}} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    index :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
