#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct WheelPanTool <: iWheelPanTool

    description :: Model.Nullable{String} = nothing

    dimension :: Model.EnumType{(:height, :width)} = :width
end
