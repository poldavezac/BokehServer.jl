#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct WidgetBox <: iWidgetBox

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    children :: Vector{iLayoutDOM}

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

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

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    spacing :: Int64 = 0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
