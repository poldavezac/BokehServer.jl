#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatePicker <: iDatePicker

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    position :: Bokeh.Model.EnumType{(:below, :auto, :above)} = :auto

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    disabled :: Bool = false

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    min_date :: Bokeh.Model.Nullable{Dates.Date} = nothing

    title :: String = ""

    subscribed_events :: Vector{Symbol}

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_date :: Bokeh.Model.Nullable{Dates.Date} = nothing

    default_size :: Int64 = 300

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    enabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Dates.Date

    disabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    inline :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end
