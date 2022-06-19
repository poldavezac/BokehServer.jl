#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iColorBar, Bokeh.Models.ColorMapper, Bokeh.Models.LabelingPolicy, Bokeh.Models.Ticker, Bokeh.Models.BaseText, Bokeh.Models.CustomJS, Bokeh.Models.TickFormatter

@model mutable struct ColorBar <: iColorBar

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    height :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    minor_tick_out :: Int64 = 0

    title_text_font :: String = "helvetica"

    bar_line_dash_offset :: Int64 = 0

    major_label_text_line_height :: Float64 = 1.2

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    bar_line_alpha :: Bokeh.Model.Percent = 1.0

    margin :: Int64 = 30

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    major_tick_out :: Int64 = 0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    title :: Bokeh.Model.Nullable{String} = nothing

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{<:iBaseText, String}}

    bar_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    color_mapper :: iColorMapper

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    major_tick_line_dash :: Bokeh.Model.DashPattern

    border_line_width :: Float64 = 1.0

    major_tick_line_dash_offset :: Int64 = 0

    title_text_line_height :: Float64 = 1.2

    bar_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    bar_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    bar_line_dash :: Bokeh.Model.DashPattern

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    formatter :: Union{<:iTickFormatter, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    label_standoff :: Int64 = 5

    padding :: Int64 = 10

    ticker :: Union{<:iTicker, Bokeh.Model.EnumType{(:auto,)}} = :auto

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    border_line_dash :: Bokeh.Model.DashPattern

    width :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    major_tick_in :: Int64 = 5

    orientation :: Bokeh.Model.EnumType{(:horizontal, :vertical, :auto)} = :auto

    border_line_dash_offset :: Int64 = 0

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    bar_line_width :: Float64 = 1.0

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = NoOverlap()

    scale_alpha :: Float64 = 1.0

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    title_standoff :: Int64 = 2

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end
