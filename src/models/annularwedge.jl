#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AnnularWedge <: iAnnularWedge

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    fill_color :: Model.ColorSpec = (value = "rgb(128,128,128)",)

    finish_angle :: Model.AngleSpec = (field = "end_angle",)

    finish_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = (value = 12.0,)

    hatch_weight :: Model.NumberSpec = (value = 1.0,)

    inner_radius :: Model.DistanceSpec = (field = "inner_radius",)

    inner_radius_units :: Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    outer_radius :: Model.DistanceSpec = (field = "outer_radius",)

    outer_radius_units :: Model.EnumType{(:screen, :data)} = :data

    start_angle :: Model.AngleSpec = (field = "start_angle",)

    start_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{AnnularWedge}) = (:x, :y, :inner_radius, :outer_radius, :start_angle, :end_angle, :direction)
