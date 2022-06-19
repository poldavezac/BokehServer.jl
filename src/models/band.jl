#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Band <: iBand

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    fill_alpha :: Bokeh.Model.Percent = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    line_dash :: Bokeh.Model.DashPattern

    line_dash_offset :: Int64 = 0

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    name :: Bokeh.Model.Nullable{String} = nothing

    source :: iDataSource = ColumnDataSource()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
