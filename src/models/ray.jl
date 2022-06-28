#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Ray <: iRay

    angle :: Model.AngleSpec = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    length :: Model.NullDistanceSpec = 0.0

    length_units :: Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "black"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{Ray}) = (:x, :y, :length, :angle)
