#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Ellipse <: iEllipse

    angle :: Model.AngleSpec = 0.0

    decorations :: Vector{iDecoration} = iDecoration[]

    fill_alpha :: Model.AlphaSpec = 1.0

    fill_color :: Model.ColorSpec = "#808080"

    hatch_alpha :: Model.AlphaSpec = 1.0

    hatch_color :: Model.ColorSpec = "#000000"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.HatchPatternSpec = :blank

    hatch_scale :: Model.NumberSpec = 12.0

    hatch_weight :: Model.NumberSpec = 1.0

    height :: Model.DistanceSpec = "height"

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "#000000"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    width :: Model.DistanceSpec = "width"

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
export Ellipse
glyphargs(::Type{Ellipse}) = (:x, :y, :width, :height, :angle)
