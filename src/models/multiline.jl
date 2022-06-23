#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct MultiLine <: iMultiLine

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

    xs :: Model.Spec{Float64} = (field = "xs",)

    ys :: Model.Spec{Float64} = (field = "ys",)
end
glyphargs(::Type{MultiLine}) = (:xs, :ys)
