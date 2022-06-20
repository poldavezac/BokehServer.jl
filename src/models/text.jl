#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Text <: iText

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    text :: Model.Spec{String} = (field = "text",)

    text_align :: Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    text_alpha :: Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    text_color :: Model.Spec{Model.Color} = (value = "rgb(68,68,68)",)

    text_font :: Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_line_height :: Model.Spec{Float64} = (value = 1.2,)

    x :: Model.Spec{Float64} = (field = "x",)

    x_offset :: Model.Spec{Float64} = (value = 0.0,)

    y :: Model.Spec{Float64} = (field = "y",)

    y_offset :: Model.Spec{Float64} = (value = 0.0,)
end
