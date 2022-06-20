#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatePicker <: iDatePicker

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Model.Nullable{Model.Color} = nothing

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    disabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    enabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    inline :: Bool = false

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_date :: Model.Nullable{Dates.Date} = nothing

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_date :: Model.Nullable{Dates.Date} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    position :: Model.EnumType{(:auto, :above, :below)} = :auto

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    title :: String = ""

    value :: Dates.Date

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
