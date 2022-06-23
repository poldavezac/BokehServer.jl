#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Line <: iLine

    line_alpha :: Model.Percent = 1.0

    line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
glyphargs(::Type{Line}) = (:x, :y)
