#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ColorBar <: iColorBar

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    bar_line_alpha :: Model.Percent = 1.0

    bar_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    bar_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    bar_line_dash :: Model.DashPattern = Int64[]

    bar_line_dash_offset :: Int64 = 0

    bar_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    bar_line_width :: Float64 = 1.0

    border_line_alpha :: Model.Percent = 1.0

    border_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    border_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Model.DashPattern = Int64[]

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    color_mapper :: iColorMapper

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    formatter :: Union{iTickFormatter, Model.EnumType{(:auto,)}} = :auto

    group :: Model.Nullable{iRendererGroup} = nothing

    height :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    label_standoff :: Int64 = 5

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    location :: Union{Tuple{Float64, Float64}, Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}} = Dict{Union{Float64, String}, Union{iBaseText, String}}()

    major_label_policy :: iLabelingPolicy = NoOverlap()

    major_label_text_align :: Model.EnumType{(:left, :right, :center)} = :left

    major_label_text_alpha :: Model.Percent = 1.0

    major_label_text_baseline :: Model.EnumType{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = :bottom

    major_label_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    major_label_text_font :: String = "helvetica"

    major_label_text_font_size :: Model.FontSize = "16px"

    major_label_text_font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    major_label_text_line_height :: Float64 = 1.2

    major_tick_in :: Int64 = 5

    major_tick_line_alpha :: Model.Percent = 1.0

    major_tick_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    major_tick_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    major_tick_line_dash :: Model.DashPattern = Int64[]

    major_tick_line_dash_offset :: Int64 = 0

    major_tick_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    major_tick_line_width :: Float64 = 1.0

    major_tick_out :: Int64 = 0

    margin :: Int64 = 30

    minor_tick_in :: Int64 = 0

    minor_tick_line_alpha :: Model.Percent = 1.0

    minor_tick_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    minor_tick_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    minor_tick_line_dash :: Model.DashPattern = Int64[]

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    minor_tick_line_width :: Float64 = 1.0

    minor_tick_out :: Int64 = 0

    orientation :: Model.EnumType{(:horizontal, :vertical, :auto)} = :auto

    padding :: Int64 = 10

    scale_alpha :: Float64 = 1.0

    ticker :: Union{iTicker, Model.EnumType{(:auto,)}} = :auto

    title :: Model.Nullable{String} = nothing

    title_standoff :: Int64 = 2

    title_text_align :: Model.EnumType{(:left, :right, :center)} = :left

    title_text_alpha :: Model.Percent = 1.0

    title_text_baseline :: Model.EnumType{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = :bottom

    title_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    title_text_font :: String = "helvetica"

    title_text_font_size :: Model.FontSize = "16px"

    title_text_font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    title_text_line_height :: Float64 = 1.2

    visible :: Bool = true

    width :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
