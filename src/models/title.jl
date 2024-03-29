#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Title <: iTitle

    align :: Model.TextAlign = :left

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

    offset :: Float64 = 0.0

    standoff :: Float64 = 10.0

    text :: Union{iBaseText, String} = ""

    text_align :: Model.TextAlign = :left

    text_alpha :: Model.Percent = 1.0

    text_baseline :: Model.TextBaseline = :bottom

    text_color :: Union{Nothing, Model.Color} = "#444444"

    text_font :: String = "helvetica"

    text_font_size :: Model.FontSize = "13px"

    text_font_style :: Model.FontStyle = :bold

    text_line_height :: Float64 = 1.0

    text_outline_color :: Union{Nothing, Model.Color} = nothing

    vertical_align :: Model.EnumType{(:top, :middle, :bottom)} = :bottom

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
export Title
