#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Label <: iLabel

    angle :: Float64 = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Union{Nothing, Model.Color} = "#808080"

    border_line_alpha :: Model.Percent = 1.0

    border_line_cap :: Model.LineCap = :butt

    border_line_color :: Union{Nothing, Model.Color} = "#000000"

    border_line_dash :: Model.DashPattern = Int64[]

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Model.LineJoin = :bevel

    border_line_width :: Float64 = 1.0

    coordinates :: Union{Nothing, iCoordinateMapping} = nothing

    group :: Union{Nothing, iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    text :: Union{iBaseText, String} = ""

    text_align :: Model.TextAlign = :left

    text_alpha :: Model.Percent = 1.0

    text_baseline :: Model.TextBaseline = :bottom

    text_color :: Union{Nothing, Model.Color} = "#444444"

    text_font :: String = "helvetica"

    text_font_size :: Model.FontSize = "16px"

    text_font_style :: Model.FontStyle = :normal

    text_line_height :: Float64 = 1.2

    text_outline_color :: Union{Nothing, Model.Color} = nothing

    visible :: Bool = true

    x :: Float64 = required

    x_offset :: Float64 = 0.0

    x_range_name :: String = "default"

    x_units :: Model.EnumType{(:canvas, :screen, :data)} = :data

    y :: Float64 = required

    y_offset :: Float64 = 0.0

    y_range_name :: String = "default"

    y_units :: Model.EnumType{(:canvas, :screen, :data)} = :data
end
export Label
