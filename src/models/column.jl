#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Column <: iColumn

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Union{Nothing, Model.Color} = nothing

    children :: Vector{iLayoutDOM} = iLayoutDOM[]

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    height :: Union{Nothing, Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Union{Nothing, NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    max_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Model.EnumType{(:auto, :min)}, Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Model.EnumType{(:fit, :max)}, Float64, Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Model.EnumType{(:fixed,)}, Int64, Model.EnumType{(:auto, :start, :center, :end)}}}, Model.EnumType{(:auto, :min, :fit, :max)}}}, Model.EnumType{(:auto, :min, :fit, :max)}} = :auto

    sizing_mode :: Union{Nothing, Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    spacing :: Int64 = 0

    visible :: Bool = true

    width :: Union{Nothing, Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
export Column
