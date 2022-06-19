#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ScientificFormatter <: iScientificFormatter

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    nan_format :: String = "-"

    power_limit_high :: Int64 = 5

    power_limit_low :: Int64 = -3

    precision :: Int64 = 10

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing
end
