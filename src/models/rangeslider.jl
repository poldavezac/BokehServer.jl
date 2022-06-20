#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct RangeSlider <: iRangeSlider

    align :: Union{Tuple{Model.EnumType{(:start, :end, :center)}, Model.EnumType{(:start, :end, :center)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    background :: Model.Nullable{Model.Color} = nothing

    bar_color :: Model.Color = "rgb(230,230,230)"

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    direction :: Model.EnumType{(:rtl, :ltr)} = :ltr

    disabled :: Bool = false

    finish :: Float64

    format :: Union{iTickFormatter, String} = ""

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    orientation :: Model.EnumType{(:vertical, :horizontal)} = :horizontal

    show_value :: Bool = true

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    start :: Float64

    step :: Float64 = 1.0

    title :: Model.Nullable{String} = ""

    tooltips :: Bool = true

    value :: Tuple{Float64, Float64}

    value_throttled :: Model.ReadOnly{Tuple{Float64, Float64}}

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
