#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LinearAxis <: iLinearAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    formatter :: iTickFormatter

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end
