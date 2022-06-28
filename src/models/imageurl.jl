#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageURL <: iImageURL

    anchor :: Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)} = :top_left

    angle :: Model.AngleSpec = 0.0

    angle_units :: Model.EnumType{(:deg, :rad, :grad, :turn)} = :rad

    dilate :: Bool = false

    global_alpha :: Model.NumberSpec = 1.0

    h :: Model.Nullable{Model.NullDistanceSpec} = nothing

    h_units :: Model.EnumType{(:screen, :data)} = :data

    retry_attempts :: Int64 = 0

    retry_timeout :: Int64 = 0

    url :: Model.NullStringSpec = (field = "url",)

    w :: Model.Nullable{Model.NullDistanceSpec} = nothing

    w_units :: Model.EnumType{(:screen, :data)} = :data

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
glyphargs(::Type{ImageURL}) = (:url, :x, :y, :w, :h, :angle, :dilate)
