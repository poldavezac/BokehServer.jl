#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDateRangeSlider, Bokeh.Models.CustomJS, Bokeh.Models.TickFormatter

@model mutable struct DateRangeSlider <: iDateRangeSlider

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    value_throttled :: Bokeh.Model.ReadOnly{Tuple{Dates.DateTime, Dates.DateTime}}

    css_classes :: Vector{String} = String[]

    show_value :: Bool = true

    visible :: Bool = true

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Dates.DateTime

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    disabled :: Bool = false

    tooltips :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{Symbol}

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    finish :: Dates.DateTime

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{<:iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Tuple{Dates.DateTime, Dates.DateTime}

    step :: Int64 = 1

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end
