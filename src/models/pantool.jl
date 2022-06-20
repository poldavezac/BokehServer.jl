#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PanTool <: iPanTool

    description :: Model.Nullable{String} = nothing

    dimensions :: Model.EnumType{(:both, :height, :width)} = :both
end
