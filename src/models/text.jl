#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Text <: iText

    angle :: Model.AngleSpec = (value = 0.0,)

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    text :: Model.Spec{String} = (field = "text",)

    text_align :: Model.TextAlignSpec = (value = :left,)

    text_alpha :: Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Model.TextBaselineSpec = (value = :bottom,)

    text_color :: Model.ColorSpec = (value = "#444444",)

    text_font :: Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Model.FontStyleSpec = (value = :normal,)

    text_line_height :: Model.NumberSpec = (value = 1.2,)

    x :: Model.NumberSpec = (field = "x",)

    x_offset :: Model.NumberSpec = (value = 0.0,)

    y :: Model.NumberSpec = (field = "y",)

    y_offset :: Model.NumberSpec = (value = 0.0,)
end
glyphargs(::Type{Text}) = (:x, :y, :text, :angle, :x_offset, :y_offset)
