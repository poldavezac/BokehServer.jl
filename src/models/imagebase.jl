#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct ImageBase <: iImageBase

    anchor :: Union{Tuple{Union{Model.Percent, Model.EnumType{(:start, :center, :end, :top, :bottom)}}, Union{Model.Percent, Model.EnumType{(:start, :center, :end, :left, :right)}}}, Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :bottom_left

    decorations :: Vector{iDecoration} = iDecoration[]

    dh :: Model.DistanceSpec = "dh"

    dilate :: Bool = false

    dw :: Model.DistanceSpec = "dw"

    global_alpha :: Model.AlphaSpec = 1.0

    origin :: Model.EnumType{(:bottom_left, :top_left, :bottom_right, :top_right)} = :bottom_left

    x :: Model.NumberSpec = "x"

    y :: Model.NumberSpec = "y"
end
export ImageBase