#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Label <: iLabel

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    text_font :: String = "helvetica"

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    text_alpha :: Bokeh.Model.Percent = 1.0

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    text :: String = ""

    tags :: Vector{Any}

    border_line_dash_offset :: Int64 = 0

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Float64

    text_line_height :: Float64 = 1.2

    angle :: Float64 = 0.0

    y_offset :: Float64 = 0.0

    text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    name :: Bokeh.Model.Nullable{String} = nothing

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    text_font_size :: Bokeh.Model.FontSize = "16px"

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    x_offset :: Float64 = 0.0

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y :: Float64

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    border_line_width :: Float64 = 1.0

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Bokeh.Model.DashPattern
end
