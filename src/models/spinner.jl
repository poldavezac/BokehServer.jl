#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Spinner <: iSpinner

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    format :: Union{Nothing, String, iTickFormatter} = nothing

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    high :: Union{Nothing, Float64, Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    low :: Union{Nothing, Float64, Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    mode :: Bokeh.Model.EnumType{(:int, :float)} = :int

    name :: Bokeh.Model.Nullable{String} = nothing

    page_step_multiplier :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    placeholder :: String = ""

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    step :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: String = ""

    value :: Union{Nothing, Float64, Int64} = nothing

    value_throttled :: Bokeh.Model.ReadOnly{Union{Nothing, Float64, Int64}} = nothing

    visible :: Bool = true

    wheel_wait :: Union{Float64, Int64} = 100

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
