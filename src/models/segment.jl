#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Segment <: iSegment

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "black"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    x0 :: Model.NumberSpec = "x0"

    x1 :: Model.NumberSpec = "x1"

    y0 :: Model.NumberSpec = "y0"

    y1 :: Model.NumberSpec = "y1"
end
glyphargs(::Type{Segment}) = (:x0, :y0, :x1, :y1)
