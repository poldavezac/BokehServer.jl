#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct LinearAxis <: iLinearAxis

    axis_label :: Bokeh.Model.Nullable{Union{String, iBaseText}} = nothing

    axis_label_standoff :: Int64 = 5

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    axis_label_text_font :: String = "helvetica"

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_label_text_line_height :: Float64 = 1.2

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    axis_line_dash :: Bokeh.Model.DashPattern

    axis_line_dash_offset :: Int64 = 0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_width :: Float64 = 1.0

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    formatter :: iTickFormatter

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_label_overrides :: Dict{Union{Float64, String}, Union{String, iBaseText}}

    major_label_policy :: iLabelingPolicy = AllLabels()

    major_label_standoff :: Int64 = 5

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_label_text_font :: String = "helvetica"

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_text_line_height :: Float64 = 1.2

    major_tick_in :: Int64 = 2

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_tick_line_width :: Float64 = 1.0

    major_tick_out :: Int64 = 6

    minor_tick_in :: Int64 = 0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_width :: Float64 = 1.0

    minor_tick_out :: Int64 = 4

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    ticker :: iTicker

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
