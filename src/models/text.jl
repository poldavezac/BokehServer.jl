#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Text <: iText

    angle :: Model.AngleSpec = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    text :: Model.NullStringSpec = (field = "text",)

    text_align :: Model.TextAlignSpec = :left

    text_alpha :: Model.AlphaSpec = 1.0

    text_baseline :: Model.TextBaselineSpec = :bottom

    text_color :: Model.ColorSpec = "#444444"

    text_font :: Model.NullStringSpec = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = "16px"

    text_font_style :: Model.FontStyleSpec = :normal

    text_line_height :: Model.NumberSpec = 1.2

    x :: Model.NumberSpec = "x"

    x_offset :: Model.NumberSpec = 0.0

    y :: Model.NumberSpec = "y"

    y_offset :: Model.NumberSpec = 0.0
end
glyphargs(::Type{Text}) = (:x, :y, :text, :angle, :x_offset, :y_offset)
