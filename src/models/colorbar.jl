#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ColorBar <: iColorBar

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    bar_line_alpha :: Bokeh.Model.Percent = 1.0

    bar_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    bar_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    bar_line_dash :: Bokeh.Model.DashPattern

    bar_line_dash_offset :: Int64 = 0

    bar_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    bar_line_width :: Float64 = 1.0

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Bokeh.Model.DashPattern

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    color_mapper :: iColorMapper

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    formatter :: Union{Bokeh.Model.EnumType{(:auto,)}, iTickFormatter} = Bokeh.Model.Unknown()

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    height :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    label_standoff :: Int64 = 5

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    major_label_overrides :: Dict{Union{Float64, String}, Union{String, iBaseText}}

    major_label_policy :: iLabelingPolicy = NoOverlap()

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_label_text_font :: String = "helvetica"

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_text_line_height :: Float64 = 1.2

    major_tick_in :: Int64 = 5

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_tick_line_width :: Float64 = 1.0

    major_tick_out :: Int64 = 0

    margin :: Int64 = 30

    minor_tick_in :: Int64 = 0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_width :: Float64 = 1.0

    minor_tick_out :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    orientation :: Bokeh.Model.EnumType{(:horizontal, :vertical, :auto)} = :auto

    padding :: Int64 = 10

    scale_alpha :: Float64 = 1.0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    ticker :: Union{Bokeh.Model.EnumType{(:auto,)}, iTicker} = Bokeh.Model.Unknown()

    title :: Bokeh.Model.Nullable{String} = nothing

    title_standoff :: Int64 = 2

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    title_text_font :: String = "helvetica"

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    title_text_line_height :: Float64 = 1.2

    visible :: Bool = true

    width :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
