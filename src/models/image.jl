#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Image <: iImage

    color_mapper :: iColorMapper = LinearColorMapper()

    dh :: Model.DistanceSpec = (field = "dh",)

    dh_units :: Model.EnumType{(:screen, :data)} = :data

    dilate :: Bool = false

    dw :: Model.DistanceSpec = (field = "dw",)

    dw_units :: Model.EnumType{(:screen, :data)} = :data

    global_alpha :: Model.NumberSpec = (value = 1.0,)

    image :: Model.NumberSpec = (field = "image",)

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{Image}) = (:image, :x, :y, :dw, :dh, :dilate)
