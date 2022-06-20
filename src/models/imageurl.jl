#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageURL <: iImageURL

    anchor :: Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :top_left

    angle :: Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    dilate :: Bool = false

    global_alpha :: Model.Spec{Float64} = (value = 1.0,)

    h :: Model.Nullable{Model.DistanceSpec} = nothing

    h_units :: Model.EnumType{(:screen, :data)} = :data

    retry_attempts :: Int64 = 0

    retry_timeout :: Int64 = 0

    url :: Model.Spec{String} = (field = "url",)

    w :: Model.Nullable{Model.DistanceSpec} = nothing

    w_units :: Model.EnumType{(:screen, :data)} = :data

    x :: Model.Spec{Float64} = (field = "x",)

    y :: Model.Spec{Float64} = (field = "y",)
end
