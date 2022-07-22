#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct BoxAnnotation <: iBoxAnnotation

    bottom :: Union{Nothing, Float64} = nothing

    bottom_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Union{Nothing, iCoordinateMapping} = nothing

    fill_alpha :: Model.Percent = 0.4

    fill_color :: Union{Nothing, Model.Color} = "#FFF9BA"

    group :: Union{Nothing, iRendererGroup} = nothing

    hatch_alpha :: Model.Percent = 1.0

    hatch_color :: Union{Nothing, Model.Color} = "#000000"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Union{Nothing, String} = nothing

    hatch_scale :: Model.Size = 12.0

    hatch_weight :: Model.Size = 1.0

    left :: Union{Nothing, Float64} = nothing

    left_units :: Model.EnumType{(:screen, :data)} = :data

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.Percent = 0.3

    line_cap :: Model.LineCap = :butt

    line_color :: Union{Nothing, Model.Color} = "#CCCCCC"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.LineJoin = :bevel

    line_width :: Float64 = 1.0

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    right :: Union{Nothing, Float64} = nothing

    right_units :: Model.EnumType{(:screen, :data)} = :data

    top :: Union{Nothing, Float64} = nothing

    top_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
export BoxAnnotation
