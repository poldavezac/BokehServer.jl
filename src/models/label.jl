#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Label <: iLabel

    angle :: Float64 = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    border_line_alpha :: Model.Percent = 1.0

    border_line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    border_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Model.DashPattern = Int64[]

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    text :: String = ""

    text_align :: Model.EnumType{(:left, :right, :center)} = :left

    text_alpha :: Model.Percent = 1.0

    text_baseline :: Model.EnumType{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = :bottom

    text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    text_font :: String = "helvetica"

    text_font_size :: Model.FontSize = "16px"

    text_font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    text_line_height :: Float64 = 1.2

    visible :: Bool = true

    x :: Float64

    x_offset :: Float64 = 0.0

    x_range_name :: String = "default"

    x_units :: Model.EnumType{(:screen, :data)} = :data

    y :: Float64

    y_offset :: Float64 = 0.0

    y_range_name :: String = "default"

    y_units :: Model.EnumType{(:screen, :data)} = :data
end
