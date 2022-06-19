#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iBand, Bokeh.Models.DataSource, Bokeh.Models.CustomJS

@model mutable struct Band <: iBand

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    line_width :: Float64 = 1.0

    x_range_name :: String = "default"

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    line_dash :: Bokeh.Model.DashPattern

    source :: iDataSource = ColumnDataSource()
end
