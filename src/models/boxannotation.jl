#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxAnnotation <: iBoxAnnotation

    bottom :: Union{Nothing, Model.EnumType{(:auto,)}, Model.Spec{Float64}} = nothing

    bottom_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    group :: Model.Nullable{iRendererGroup} = nothing

    hatch_alpha :: Model.Percent = 1.0

    hatch_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Model.Nullable{String} = nothing

    hatch_scale :: Model.Size = 12.0

    hatch_weight :: Model.Size = 1.0

    left :: Union{Nothing, Model.EnumType{(:auto,)}, Model.Spec{Float64}} = nothing

    left_units :: Model.EnumType{(:screen, :data)} = :data

    level :: Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_alpha :: Model.Percent = 1.0

    line_cap :: Model.EnumType{(:round, :square, :butt)} = :butt

    line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    line_dash :: Model.DashPattern

    line_dash_offset :: Int64 = 0

    line_join :: Model.EnumType{(:round, :miter, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    right :: Union{Nothing, Model.EnumType{(:auto,)}, Model.Spec{Float64}} = nothing

    right_units :: Model.EnumType{(:screen, :data)} = :data

    top :: Union{Nothing, Model.EnumType{(:auto,)}, Model.Spec{Float64}} = nothing

    top_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
