#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LabelSet <: iLabelSet

    angle :: Model.AngleSpec = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    background_fill_alpha :: Model.AlphaSpec = 1.0

    background_fill_color :: Model.ColorSpec = nothing

    border_line_alpha :: Model.AlphaSpec = 1.0

    border_line_cap :: Model.LineCapSpec = :butt

    border_line_color :: Model.ColorSpec = nothing

    border_line_dash :: Model.DashPatternSpec = Int64[]

    border_line_dash_offset :: Model.IntSpec = 0

    border_line_join :: Model.LineJoinSpec = :bevel

    border_line_width :: Model.NumberSpec = 1.0

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    source :: iDataSource = ColumnDataSource()

    text :: Model.NullStringSpec = (field = "text",)

    text_align :: Model.TextAlignSpec = :left

    text_alpha :: Model.AlphaSpec = 1.0

    text_baseline :: Model.TextBaselineSpec = :bottom

    text_color :: Model.ColorSpec = "#444444"

    text_font :: Model.NullStringSpec = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = "16px"

    text_font_style :: Model.FontStyleSpec = :normal

    text_line_height :: Model.NumberSpec = 1.2

    visible :: Bool = true

    x :: Model.NumberSpec = "x"

    x_offset :: Model.NumberSpec = 0.0

    x_range_name :: String = "default"

    x_units :: Model.EnumType{(:screen, :data)} = :data

    y :: Model.NumberSpec = "y"

    y_offset :: Model.NumberSpec = 0.0

    y_range_name :: String = "default"

    y_units :: Model.EnumType{(:screen, :data)} = :data
end
