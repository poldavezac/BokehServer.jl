#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Arc <: iArc

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    finish_angle :: Model.AngleSpec = (field = "end_angle",)

    finish_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    radius :: Model.DistanceSpec = (field = "radius",)

    radius_units :: Model.EnumType{(:screen, :data)} = :data

    start_angle :: Model.AngleSpec = (field = "start_angle",)

    start_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{Arc}) = (:x, :y, :radius, :start_angle, :end_angle, :direction)
