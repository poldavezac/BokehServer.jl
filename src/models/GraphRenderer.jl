#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iGraphRenderer, Bokeh.Models.GlyphRenderer, Bokeh.Models.CustomJS, Bokeh.Models.LayoutProvider, Bokeh.Models.GraphHitTestPolicy

@model mutable struct GraphRenderer <: iGraphRenderer

    syncable :: Bool = true

    layout_provider :: iLayoutProvider

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    edge_renderer :: iGlyphRenderer = GlyphRenderer()

    inspection_policy :: iGraphHitTestPolicy = NodesOnly()

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    node_renderer :: iGlyphRenderer = GlyphRenderer()

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    selection_policy :: iGraphHitTestPolicy = NodesOnly()

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
