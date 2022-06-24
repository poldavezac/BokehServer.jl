#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LabelSet <: iLabelSet

    angle :: Model.AngleSpec = (value = 0.0,)

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    background_fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    background_fill_color :: Model.ColorSpec = nothing

    border_line_alpha :: Model.AlphaSpec = (value = 1.0,)

    border_line_cap :: Model.LineCapSpec = (value = :butt,)

    border_line_color :: Model.ColorSpec = nothing

    border_line_dash :: Model.DashPatternSpec = (value = Int64[],)

    border_line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    border_line_join :: Model.LineJoinSpec = (value = :bevel,)

    border_line_width :: Model.NumberSpec = (value = 1.0,)

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    source :: iDataSource = ColumnDataSource()

    text :: Model.Spec{String} = (field = "text",)

    text_align :: Model.TextAlignSpec = (value = :left,)

    text_alpha :: Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Model.TextBaselineSpec = (value = :bottom,)

    text_color :: Model.ColorSpec = (value = "rgb(68,68,68)",)

    text_font :: Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Model.FontStyleSpec = (value = :normal,)

    text_line_height :: Model.NumberSpec = (value = 1.2,)

    visible :: Bool = true

    x :: Model.NumberSpec = (field = "x",)

    x_offset :: Model.NumberSpec = (value = 0.0,)

    x_range_name :: String = "default"

    x_units :: Model.EnumType{(:screen, :data)} = :data

    y :: Model.NumberSpec = (field = "y",)

    y_offset :: Model.NumberSpec = (value = 0.0,)

    y_range_name :: String = "default"

    y_units :: Model.EnumType{(:screen, :data)} = :data
end
