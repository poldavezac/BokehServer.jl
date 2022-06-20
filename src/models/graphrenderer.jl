#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GraphRenderer <: iGraphRenderer

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    edge_renderer :: iGlyphRenderer = GlyphRenderer()

    group :: Model.Nullable{iRendererGroup} = nothing

    inspection_policy :: iGraphHitTestPolicy = NodesOnly()

    layout_provider :: iLayoutProvider

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    node_renderer :: iGlyphRenderer = GlyphRenderer()

    selection_policy :: iGraphHitTestPolicy = NodesOnly()

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
