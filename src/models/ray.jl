#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Ray <: iRay

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    length :: Model.DistanceSpec = (value = 0.0,)

    length_units :: Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
glyphargs(::Type{Ray}) = (:x, :y, :length, :angle)
