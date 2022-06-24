#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct OpenHead <: iOpenHead

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    size :: Model.NumberSpec = (value = 25.0,)
end
