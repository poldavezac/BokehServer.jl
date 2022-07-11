#- file generated by BokehJL's 'CodeCreator': edit at your own risk! -#

@model mutable struct RadioButtonGroup <: iRadioButtonGroup

    active :: Union{Nothing, Int64} = nothing

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Union{Nothing, Model.Color} = nothing

    button_type :: Model.EnumType{(:default, :primary, :success, :warning, :danger, :light)} = :default

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    height :: Union{Nothing, Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    labels :: Vector{String} = String[]

    margin :: Union{Nothing, NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    max_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    orientation :: Model.EnumType{(:horizontal, :vertical)} = :horizontal

    sizing_mode :: Union{Nothing, Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    visible :: Bool = true

    width :: Union{Nothing, Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
