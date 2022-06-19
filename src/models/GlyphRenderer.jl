#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iGlyphRenderer, Bokeh.Models.DataSource, Bokeh.Models.CustomJS, Bokeh.Models.Glyph, Bokeh.Models.CDSView

@model mutable struct GlyphRenderer <: iGlyphRenderer

    syncable :: Bool = true

    selection_glyph :: Bokeh.Model.Nullable{Union{<:iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    nonselection_glyph :: Bokeh.Model.Nullable{Union{<:iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    muted :: Bool = false

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    glyph :: iGlyph

    name :: Bokeh.Model.Nullable{String} = nothing

    hover_glyph :: Bokeh.Model.Nullable{<:iGlyph} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    muted_glyph :: Bokeh.Model.Nullable{Union{<:iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    view :: iCDSView

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    data_source :: iDataSource

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
