#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Scatter <: iScatter

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    fill_color :: Model.Spec{Model.Color} = (value = "rgb(128,128,128)",)

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hatch_scale :: Model.Spec{Float64} = (value = 12.0,)

    hatch_weight :: Model.Spec{Float64} = (value = 1.0,)

    hit_dilation :: Model.Size = 1.0

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.Spec{Model.DashPattern}

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

    marker :: Model.EnumSpec{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = (value = :circle,)

    size :: Model.SizeSpec = (value = 4.0,)

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
