#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct MultiChoice <: iMultiChoice

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    delete_button :: Bool = true

    disabled :: Bool = false

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_items :: Bokeh.Model.Nullable{Int64} = nothing

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    option_limit :: Bokeh.Model.Nullable{Int64} = nothing

    options :: Vector{Union{String, Tuple{String, String}}}

    placeholder :: Bokeh.Model.Nullable{String} = nothing

    search_option_limit :: Bokeh.Model.Nullable{Int64} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    solid :: Bool = true

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: String = ""

    value :: Vector{String} = String[]

    visible :: Bool = true

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
