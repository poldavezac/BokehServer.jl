#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Patches <: iPatches

    fill_alpha :: Model.AlphaSpec = (value = 1.0,)

    fill_color :: Model.ColorSpec = (value = "rgb(128,128,128)",)

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = (value = 12.0,)

    hatch_weight :: Model.NumberSpec = (value = 1.0,)

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    xs :: Model.NumberSpec = (field = "xs",)

    ys :: Model.NumberSpec = (field = "ys",)
end
glyphargs(::Type{Patches}) = (:xs, :ys)
