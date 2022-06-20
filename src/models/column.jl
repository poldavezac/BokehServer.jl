#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Column <: iColumn

    align :: Union{Tuple{Model.EnumType{(:start, :end, :center)}, Model.EnumType{(:start, :end, :center)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Model.Nullable{Model.Color} = nothing

    children :: Vector{iLayoutDOM}

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Model.EnumType{(:auto, :min)}, Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Model.EnumType{(:max, :fit)}, Float64, Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Model.EnumType{(:fixed,)}, Int64, Model.EnumType{(:auto, :start, :center, :end)}}}, Model.EnumType{(:auto, :min, :fit, :max)}}}, Model.EnumType{(:auto, :min, :fit, :max)}} = :auto

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    spacing :: Int64 = 0

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
