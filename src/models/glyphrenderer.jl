#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GlyphRenderer <: iGlyphRenderer

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    data_source :: iDataSource

    glyph :: iGlyph

    group :: Model.Nullable{iRendererGroup} = nothing

    hover_glyph :: Model.Nullable{iGlyph} = nothing

    level :: Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    muted :: Bool = false

    muted_glyph :: Model.Nullable{Union{iGlyph, Model.EnumType{(:auto,)}}} = :auto

    nonselection_glyph :: Model.Nullable{Union{iGlyph, Model.EnumType{(:auto,)}}} = :auto

    selection_glyph :: Model.Nullable{Union{iGlyph, Model.EnumType{(:auto,)}}} = :auto

    view :: iCDSView

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
