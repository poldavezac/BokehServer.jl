#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxZoomTool <: iBoxZoomTool

    description :: Model.Nullable{String} = nothing

    dimensions :: Model.EnumType{(:both, :height, :width)} = :both

    match_aspect :: Bool = false

    origin :: Model.EnumType{(:corner, :center)} = :corner

    overlay :: iBoxAnnotation = BoxAnnotation()
end
