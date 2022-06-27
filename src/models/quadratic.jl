#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Quadratic <: iQuadratic

    cx :: Model.NumberSpec = (field = "cx",)

    cy :: Model.NumberSpec = (field = "cy",)

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "#000000",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    x0 :: Model.NumberSpec = (field = "x0",)

    x1 :: Model.NumberSpec = (field = "x1",)

    y0 :: Model.NumberSpec = (field = "y0",)

    y1 :: Model.NumberSpec = (field = "y1",)
end
glyphargs(::Type{Quadratic}) = (:x0, :y0, :x1, :y1, :cx, :cy)
