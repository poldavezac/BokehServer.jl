#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Circle <: iCircle

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

    hit_dilation :: Model.Size = 1.0

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "#000000"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    radius :: Model.NullDistanceSpec = nothing

    radius_dimension :: Model.EnumType{(:x, :y, :max, :min)} = :x

    size :: Model.SizeSpec = 4.0

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
export Circle
glyphargs(::Type{Circle}) = (:x, :y)
