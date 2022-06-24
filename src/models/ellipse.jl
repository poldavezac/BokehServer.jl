#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Ellipse <: iEllipse

    angle :: Model.AngleSpec = (value = 0.0,)

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    fill_color :: Model.ColorSpec = (value = "rgb(128,128,128)",)

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = (value = 12.0,)

    hatch_weight :: Model.NumberSpec = (value = 1.0,)

    height :: Model.DistanceSpec = (field = "height",)

    height_units :: Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    width :: Model.DistanceSpec = (field = "width",)

    width_units :: Model.EnumType{(:screen, :data)} = :data

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{Ellipse}) = (:x, :y, :width, :height, :angle)
