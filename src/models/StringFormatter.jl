#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStringFormatter, Bokeh.Models.CustomJS

@model mutable struct StringFormatter <: iStringFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
