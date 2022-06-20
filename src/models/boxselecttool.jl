#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxSelectTool <: iBoxSelectTool

    description :: Model.Nullable{String} = nothing

    dimensions :: Model.EnumType{(:both, :height, :width)} = :both

    mode :: Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    names :: Vector{String} = String[]

    origin :: Model.EnumType{(:corner, :center)} = :corner

    overlay :: iBoxAnnotation = BoxAnnotation()

    renderers :: Union{Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    select_every_mousemove :: Bool = false
end
