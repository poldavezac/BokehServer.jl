#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GraphRenderer <: iGraphRenderer

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    edge_renderer :: iGlyphRenderer = GlyphRenderer()

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    inspection_policy :: iGraphHitTestPolicy = NodesOnly()

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    layout_provider :: iLayoutProvider

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    name :: Bokeh.Model.Nullable{String} = nothing

    node_renderer :: iGlyphRenderer = GlyphRenderer()

    selection_policy :: iGraphHitTestPolicy = NodesOnly()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
