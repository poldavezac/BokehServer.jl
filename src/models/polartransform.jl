#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PolarTransform <: iPolarTransform

    angle :: Model.AngleSpec = "angle"

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    radius :: Model.NumberSpec = "radius"
end
