#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct PolarTransform <: iPolarTransform

    angle :: Model.AngleSpec = "angle"

    direction :: Model.EnumType{(:clock, :anticlock)} = :anticlock

    radius :: Model.NumberSpec = "radius"
end
export PolarTransform
