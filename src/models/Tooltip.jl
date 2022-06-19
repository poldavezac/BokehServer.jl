#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iTooltip, Bokeh.Models.CustomJS

@model mutable struct Tooltip <: iTooltip

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    inner_only :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    show_arrow :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal
end
