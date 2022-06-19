#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Tooltip <: iTooltip

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    inner_only :: Bool = true

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    name :: Bokeh.Model.Nullable{String} = nothing

    show_arrow :: Bool = true

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
