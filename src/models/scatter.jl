#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Scatter <: iScatter

    angle :: Model.AngleSpec = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    fill_alpha :: Model.AlphaSpec = 1.0

    fill_color :: Model.ColorSpec = "gray"

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "black"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    hit_dilation :: Model.Size = 1.0

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "black"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    marker :: Model.MarkerSpec = :circle

    size :: Model.SizeSpec = 4.0

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{Scatter}) = (:x, :y, :size, :angle, :marker)
