#- file generated by BokehJL's 'CodeCreator': edit at your own risk! -#

@model mutable struct HArea <: iHArea

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Union{Nothing, Model.Color} = "#808080"

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "#000000"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    x1 :: Model.NumberSpec = "x1"

    x2 :: Model.NumberSpec = "x2"

    y :: Model.NumberSpec = "y"
end
export HArea
glyphargs(::Type{HArea}) = (:x1, :x2, :y)
