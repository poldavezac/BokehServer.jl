#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Arc <: iArc

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    finish_angle :: Model.AngleSpec = "end_angle"

    finish_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "black"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    radius :: Model.NullDistanceSpec = "radius"

    radius_units :: Model.EnumType{(:screen, :data)} = :data

    start_angle :: Model.AngleSpec = "start_angle"

    start_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{Arc}) = (:x, :y, :radius, :start_angle, :end_angle, :direction)
