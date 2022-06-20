#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PolarTransform <: iPolarTransform

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "angle",)

    angle_units :: Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    radius :: Model.Spec{Float64} = (field = "radius",)
end
