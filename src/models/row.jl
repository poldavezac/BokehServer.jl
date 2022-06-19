#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Row <: iRow

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    spacing :: Int64 = 0

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    disabled :: Bool = false

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{Symbol}

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    cols :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :width, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    children :: Vector{iLayoutDOM}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end
