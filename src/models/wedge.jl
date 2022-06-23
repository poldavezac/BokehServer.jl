#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Wedge <: iWedge

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    fill_color :: Model.Spec{Model.Color} = (value = "rgb(128,128,128)",)

    finish_angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    finish_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hatch_scale :: Model.Spec{Float64} = (value = 12.0,)

    hatch_weight :: Model.Spec{Float64} = (value = 1.0,)

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.Spec{Model.DashPattern}

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

    radius :: Model.DistanceSpec = (field = "radius",)

    radius_units :: Model.EnumType{(:screen, :data)} = :data

    start_angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    start_angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
glyphargs(::Type{Wedge}) = (:x, :y, :radius, :start_angle, :end_angle, :direction)
