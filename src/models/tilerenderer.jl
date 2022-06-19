#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TileRenderer <: iTileRenderer

    syncable :: Bool = true

    alpha :: Float64 = 1.0

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    smoothing :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    tile_source :: iTileSource = WMTSTileSource()

    subscribed_events :: Vector{Symbol}

    render_parents :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
