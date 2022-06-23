#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Legend <: iLegend

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    border_line_alpha :: Model.Percent = 1.0

    border_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    border_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Model.DashPattern = Int64[]

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    click_policy :: Model.EnumType{(:none, :hide, :mute)} = :none

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    glyph_height :: Int64 = 20

    glyph_width :: Int64 = 20

    group :: Model.Nullable{iRendererGroup} = nothing

    inactive_fill_alpha :: Model.Percent = 1.0

    inactive_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    items :: Vector{iLegendItem} = iLegendItem[]

    label_height :: Int64 = 20

    label_standoff :: Int64 = 5

    label_text_align :: Model.EnumType{(:left, :right, :center)} = :left

    label_text_alpha :: Model.Percent = 1.0

    label_text_baseline :: Model.EnumType{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = :bottom

    label_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    label_text_font :: String = "helvetica"

    label_text_font_size :: Model.FontSize = "16px"

    label_text_font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    label_text_line_height :: Float64 = 1.2

    label_width :: Int64 = 20

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    location :: Union{Tuple{Float64, Float64}, Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    margin :: Int64 = 10

    orientation :: Model.EnumType{(:horizontal, :vertical)} = :vertical

    padding :: Int64 = 10

    spacing :: Int64 = 3

    title :: Model.Nullable{String} = nothing

    title_standoff :: Int64 = 5

    title_text_align :: Model.EnumType{(:left, :right, :center)} = :left

    title_text_alpha :: Model.Percent = 1.0

    title_text_baseline :: Model.EnumType{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = :bottom

    title_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    title_text_font :: String = "helvetica"

    title_text_font_size :: Model.FontSize = "16px"

    title_text_font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    title_text_line_height :: Float64 = 1.2

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
