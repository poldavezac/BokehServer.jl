#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Step <: iStep

    line_alpha :: Model.Percent = 1.0

    line_cap :: Model.LineCap = :butt

    line_color :: Model.Nullable{Model.Color} = "#000000"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.LineJoin = :bevel

    line_width :: Float64 = 1.0

    mode :: Model.EnumType{(:before, :after, :center)} = :before

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{Step}) = (:x, :y)
