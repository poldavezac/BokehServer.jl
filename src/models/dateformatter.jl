#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DateFormatter <: iDateFormatter

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    format :: Union{String, Bokeh.Model.EnumType{(:ATOM, :W3C, Symbol("RFC-3339"), Symbol("ISO-8601"), :COOKIE, Symbol("RFC-822"), Symbol("RFC-850"), Symbol("RFC-1036"), Symbol("RFC-1123"), Symbol("RFC-2822"), :RSS, :TIMESTAMP)}} = Symbol("ISO-8601")

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    nan_format :: String = "-"

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing
end
