#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Label <: iLabel

    angle :: Float64 = 0.0

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Bokeh.Model.DashPattern

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    name :: Bokeh.Model.Nullable{String} = nothing

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text :: String = ""

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    text_alpha :: Bokeh.Model.Percent = 1.0

    text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    text_font :: String = "helvetica"

    text_font_size :: Bokeh.Model.FontSize = "16px"

    text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    text_line_height :: Float64 = 1.2

    visible :: Bool = true

    x :: Float64

    x_offset :: Float64 = 0.0

    x_range_name :: String = "default"

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y :: Float64

    y_offset :: Float64 = 0.0

    y_range_name :: String = "default"

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end
