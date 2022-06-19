#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HoverTool <: iHoverTool

    syncable :: Bool = true

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_policy :: Bokeh.Model.EnumType{(:none, :nearest, :interp, :prev, :next)} = :nearest

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    toggleable :: Bool = true

    tags :: Vector{Any}

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{Symbol}

    mode :: Bokeh.Model.EnumType{(:mouse, :vline, :hline)} = :mouse

    point_policy :: Bokeh.Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    show_arrow :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    muted_policy :: Bokeh.Model.EnumType{(:ignore, :show)} = :show

    formatters :: Dict{String, Union{iCustomJSHover, Bokeh.Model.EnumType{(:numeral, :datetime, :printf)}}}

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :center
end
