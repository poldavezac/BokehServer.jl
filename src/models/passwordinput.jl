#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PasswordInput <: iPasswordInput

    align :: Union{Tuple{Model.EnumType{(:start, :end, :center)}, Model.EnumType{(:start, :end, :center)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Model.Nullable{Model.Color} = nothing

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_length :: Model.Nullable{Int64} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    placeholder :: String = ""

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    title :: String = ""

    value :: String = ""

    value_input :: String = ""

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
