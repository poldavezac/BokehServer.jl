#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TapTool <: iTapTool

    behavior :: Model.EnumType{(:select, :inspect)} = :select

    callback :: Model.Nullable{iCallback} = nothing

    description :: Model.Nullable{String} = nothing

    gesture :: Model.EnumType{(:tap, :doubletap)} = :tap

    mode :: Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    names :: Vector{String} = String[]

    renderers :: Union{Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto
end
