#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iSpan, Bokeh.Models.CustomJS

@model mutable struct Span <: iSpan

    syncable :: Bool = true

    location :: Bokeh.Model.Nullable{Float64} = nothing

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    location_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y_range_name :: String = "default"

    line_width :: Float64 = 1.0

    x_range_name :: String = "default"

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :width

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    line_dash :: Bokeh.Model.DashPattern
end
