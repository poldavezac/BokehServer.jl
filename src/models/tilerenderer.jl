#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TileRenderer <: iTileRenderer

    alpha :: Float64 = 1.0

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    render_parents :: Bool = true

    smoothing :: Bool = true

    tile_source :: iTileSource = WMTSTileSource()

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
