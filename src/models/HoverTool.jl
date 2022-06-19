#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iHoverTool, Bokeh.Models.DomTemplate, Bokeh.Models.CustomJSHover, Bokeh.Models.DataRenderer, Bokeh.Models.CustomJS

@model mutable struct HoverTool <: iHoverTool

    syncable :: Bool = true

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    line_policy :: Bokeh.Model.EnumType{(:none, :nearest, :interp, :prev, :next)} = :nearest

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{<:iDataRenderer}} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    toggleable :: Bool = true

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    mode :: Bokeh.Model.EnumType{(:mouse, :vline, :hline)} = :mouse

    point_policy :: Bokeh.Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    show_arrow :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    callback :: Bokeh.Model.Nullable{<:iCallback} = nothing

    names :: Vector{String} = String[]

    muted_policy :: Bokeh.Model.EnumType{(:ignore, :show)} = :show

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :center

    formatters :: Dict{String, Union{<:iCustomJSHover, Bokeh.Model.EnumType{(:numeral, :datetime, :printf)}}}
end
