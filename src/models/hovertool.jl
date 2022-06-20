#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct HoverTool <: iHoverTool

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :center

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    formatters :: Dict{String, Union{Bokeh.Model.EnumType{(:numeral, :datetime, :printf)}, iCustomJSHover}}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_policy :: Bokeh.Model.EnumType{(:none, :nearest, :interp, :prev, :next)} = :nearest

    mode :: Bokeh.Model.EnumType{(:mouse, :vline, :hline)} = :mouse

    muted_policy :: Bokeh.Model.EnumType{(:ignore, :show)} = :show

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    point_policy :: Bokeh.Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    show_arrow :: Bool = true

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    toggleable :: Bool = true

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = Bokeh.Model.Unknown()
end
