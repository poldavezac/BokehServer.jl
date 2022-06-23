#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Bezier <: iBezier

    cx0 :: Model.Spec{Float64} = (field = "cx0",)

    cx1 :: Model.Spec{Float64} = (field = "cx1",)

    cy0 :: Model.Spec{Float64} = (field = "cy0",)

    cy1 :: Model.Spec{Float64} = (field = "cy1",)

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

    x0 :: Model.Spec{Float64} = (field = "x0",)

    x1 :: Model.Spec{Float64} = (field = "x1",)

    y0 :: Model.Spec{Float64} = (field = "y0",)

    y1 :: Model.Spec{Float64} = (field = "y1",)
end
glyphargs(::Type{Bezier}) = (:x0, :y0, :x1, :y1, :cx0, :cy0, :cx1, :cy1)
