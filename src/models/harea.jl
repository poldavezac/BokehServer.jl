#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HArea <: iHArea

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hatch_scale :: Model.Spec{Float64} = (value = 12.0,)

    hatch_weight :: Model.Spec{Float64} = (value = 1.0,)

    x1 :: Model.Spec{Float64} = (field = "x1",)

    x2 :: Model.Spec{Float64} = (field = "x2",)

    y :: Model.Spec{Float64} = (field = "y",)
end
