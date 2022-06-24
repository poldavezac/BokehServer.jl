#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageURL <: iImageURL

    anchor :: Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)} = :top_left

    angle :: Model.AngleSpec = (value = 0.0,)

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    dilate :: Bool = false

    global_alpha :: Model.NumberSpec = (value = 1.0,)

    h :: Model.NullDistanceSpec = nothing

    h_units :: Model.EnumType{(:screen, :data)} = :data

    retry_attempts :: Int64 = 0

    retry_timeout :: Int64 = 0

    url :: Model.Spec{String} = (field = "url",)

    w :: Model.NullDistanceSpec = nothing

    w_units :: Model.EnumType{(:screen, :data)} = :data

    x :: Model.NumberSpec = (field = "x",)

    y :: Model.NumberSpec = (field = "y",)
end
glyphargs(::Type{ImageURL}) = (:url, :x, :y, :w, :h, :angle, :dilate)
