#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct GlyphRenderer <: iGlyphRenderer

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    data_source :: iDataSource

    glyph :: iGlyph

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    hover_glyph :: Bokeh.Model.Nullable{iGlyph} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    muted :: Bool = false

    muted_glyph :: Bokeh.Model.Nullable{Union{Bokeh.Model.EnumType{(:auto,)}, iGlyph}} = Bokeh.Model.Unknown()

    name :: Bokeh.Model.Nullable{String} = nothing

    nonselection_glyph :: Bokeh.Model.Nullable{Union{Bokeh.Model.EnumType{(:auto,)}, iGlyph}} = Bokeh.Model.Unknown()

    selection_glyph :: Bokeh.Model.Nullable{Union{Bokeh.Model.EnumType{(:auto,)}, iGlyph}} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    view :: iCDSView

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
