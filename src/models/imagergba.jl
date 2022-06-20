#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageRGBA <: iImageRGBA

    dh :: Model.DistanceSpec = (field = "dh",)

    dh_units :: Model.EnumType{(:screen, :data)} = :data

    dilate :: Bool = false

    dw :: Model.DistanceSpec = (field = "dw",)

    dw_units :: Model.EnumType{(:screen, :data)} = :data

    global_alpha :: Model.Spec{Float64} = (value = 1.0,)

    image :: Model.Spec{Float64} = (field = "image",)

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
