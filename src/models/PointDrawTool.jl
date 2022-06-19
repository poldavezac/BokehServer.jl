#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iPointDrawTool, Bokeh.Models.GlyphRenderer, Bokeh.Models.CustomJS

@model mutable struct PointDrawTool <: iPointDrawTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{<:iGlyphRenderer}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    add :: Bool = true

    drag :: Bool = true

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
