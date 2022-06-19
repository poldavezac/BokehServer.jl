#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Spinner <: iSpinner

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    value_throttled :: Bokeh.Model.ReadOnly{Union{Nothing, Float64, Int64}} = nothing

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    disabled :: Bool = false

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{Symbol}

    title :: String = ""

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    page_step_multiplier :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    mode :: Bokeh.Model.EnumType{(:int, :float)} = :int

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    wheel_wait :: Union{Float64, Int64} = 100

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{Nothing, iTickFormatter, String} = nothing

    placeholder :: String = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Union{Nothing, Float64, Int64} = nothing

    high :: Union{Nothing, Float64, Int64} = nothing

    step :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    low :: Union{Nothing, Float64, Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end
