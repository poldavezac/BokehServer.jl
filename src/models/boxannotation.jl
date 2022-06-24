#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxAnnotation <: iBoxAnnotation

    bottom :: Union{Nothing, Model.EnumType{(:auto,)}, Model.NumberSpec} = nothing

    bottom_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    fill_alpha :: Model.Percent = 0.4

    fill_color :: Model.Nullable{Model.Color} = "rgb(255,249,186)"

    group :: Model.Nullable{iRendererGroup} = nothing

    hatch_alpha :: Model.Percent = 1.0

    hatch_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    hatch_pattern :: Model.Nullable{String} = nothing

    hatch_scale :: Model.Size = 12.0

    hatch_weight :: Model.Size = 1.0

    left :: Union{Nothing, Model.EnumType{(:auto,)}, Model.NumberSpec} = nothing

    left_units :: Model.EnumType{(:screen, :data)} = :data

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.Percent = 0.3

    line_cap :: Model.LineCap = :butt

    line_color :: Model.Nullable{Model.Color} = "rgb(204,204,204)"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.LineJoin = :bevel

    line_width :: Float64 = 1.0

    render_mode :: Model.EnumType{(:canvas, :css)} = :canvas

    right :: Union{Nothing, Model.EnumType{(:auto,)}, Model.NumberSpec} = nothing

    right_units :: Model.EnumType{(:screen, :data)} = :data

    top :: Union{Nothing, Model.EnumType{(:auto,)}, Model.NumberSpec} = nothing

    top_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
