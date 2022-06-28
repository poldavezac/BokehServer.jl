#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HArea <: iHArea

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "#808080"

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "black"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    x1 :: Model.NumberSpec = "x1"

    x2 :: Model.NumberSpec = "x2"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{HArea}) = (:x1, :x2, :y)
