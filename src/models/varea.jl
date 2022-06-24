#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct VArea <: iVArea

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    hatch_alpha :: Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = (value = 12.0,)

    hatch_weight :: Model.NumberSpec = (value = 1.0,)

    x :: Model.NumberSpec = (field = "x",)

    y1 :: Model.NumberSpec = (field = "y1",)

    y2 :: Model.NumberSpec = (field = "y2",)
end
glyphargs(::Type{VArea}) = (:x, :y1, :y2)
