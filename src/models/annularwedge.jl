#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AnnularWedge <: iAnnularWedge

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    fill_alpha :: Model.AlphaSpec = 1.0

    fill_color :: Model.ColorSpec = "#808080"

    finish_angle :: Model.AngleSpec = "end_angle"

    finish_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "#000000"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    inner_radius :: Model.NullDistanceSpec = "inner_radius"

    inner_radius_units :: Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "#000000"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    outer_radius :: Model.NullDistanceSpec = "outer_radius"

    outer_radius_units :: Model.EnumType{(:screen, :data)} = :data

    start_angle :: Model.AngleSpec = "start_angle"

    start_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{AnnularWedge}) = (:x, :y, :inner_radius, :outer_radius, :start_angle, :finish_angle, :direction)
