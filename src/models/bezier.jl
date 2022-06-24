#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Bezier <: iBezier

    cx0 :: Model.NumberSpec = (field = "cx0",)

    cx1 :: Model.NumberSpec = (field = "cx1",)

    cy0 :: Model.NumberSpec = (field = "cy0",)

    cy1 :: Model.NumberSpec = (field = "cy1",)

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    x0 :: Model.NumberSpec = (field = "x0",)

    x1 :: Model.NumberSpec = (field = "x1",)

    y0 :: Model.NumberSpec = (field = "y0",)

    y1 :: Model.NumberSpec = (field = "y1",)
end
glyphargs(::Type{Bezier}) = (:x0, :y0, :x1, :y1, :cx0, :cy0, :cx1, :cy1)
