#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Patch <: iPatch

    fill_alpha :: Model.Percent = 1.0

    fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    hatch_alpha :: Model.Percent = 1.0

    hatch_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Model.Nullable{String} = nothing

    hatch_scale :: Model.Size = 12.0

    hatch_weight :: Model.Size = 1.0

    line_alpha :: Model.Percent = 1.0

    line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    line_dash :: Model.DashPattern

    line_dash_offset :: Int64 = 0

    line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
glyphargs(::Type{Patch}) = (:x, :y)
