#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LabelSet <: iLabelSet

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    background_fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    background_fill_color :: Model.Spec{Model.Color} = (value = "rgb(128,128,128)",)

    border_line_alpha :: Model.AlphaSpec = (value = 1.0,)

    border_line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    border_line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    border_line_dash :: Model.Spec{Model.DashPattern}

    border_line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    border_line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    border_line_width :: Model.Spec{Float64} = (value = 1.0,)

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    source :: iDataSource = ColumnDataSource()

    text :: Model.Spec{String} = (field = "text",)

    text_align :: Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    text_alpha :: Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    text_color :: Model.Spec{Model.Color} = (value = "rgb(68,68,68)",)

    text_font :: Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_line_height :: Model.Spec{Float64} = (value = 1.2,)

    visible :: Bool = true

    x :: Model.Spec{Float64} = (field = "x",)

    x_offset :: Model.Spec{Float64} = (value = 0.0,)

    x_range_name :: String = "default"

    x_units :: Model.EnumType{(:screen, :data)} = :data

    y :: Model.Spec{Float64} = (field = "y",)

    y_offset :: Model.Spec{Float64} = (value = 0.0,)

    y_range_name :: String = "default"

    y_units :: Model.EnumType{(:screen, :data)} = :data
end
