#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageRGBA <: iImageRGBA

    dh :: Model.NullDistanceSpec = "dh"

    dh_units :: Model.EnumType{(:screen, :data)} = :data

    dilate :: Bool = false

    dw :: Model.NullDistanceSpec = "dw"

    dw_units :: Model.EnumType{(:screen, :data)} = :data

    global_alpha :: Model.NumberSpec = 1.0

    image :: Model.NumberSpec = "image"

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{ImageRGBA}) = (:image, :x, :y, :dw, :dh, :dilate)
