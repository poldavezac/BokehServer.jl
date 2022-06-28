#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct VArea <: iVArea

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "#808080"

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "black"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    x :: Model.NumberSpec = "x"

    y1 :: Model.NumberSpec = "y1"

    y2 :: Model.NumberSpec = "y2"
end
glyphargs(::Type{VArea}) = (:x, :y1, :y2)
