#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Slider <: iSlider

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    disabled :: Bool = false

    finish :: Float64

    format :: Union{String, iTickFormatter} = ""

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    show_value :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    start :: Float64

    step :: Float64 = 1.0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: Bokeh.Model.Nullable{String} = ""

    tooltips :: Bool = true

    value :: Float64

    value_throttled :: Bokeh.Model.ReadOnly{Float64}

    visible :: Bool = true

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
