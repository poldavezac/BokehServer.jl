#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HoverTool <: iHoverTool

    anchor :: Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :center

    attachment :: Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    callback :: Model.Nullable{iCallback} = nothing

    description :: Model.Nullable{String} = nothing

    formatters :: Dict{String, Union{iCustomJSHover, Model.EnumType{(:numeral, :datetime, :printf)}}}

    line_policy :: Model.EnumType{(:none, :nearest, :interp, :prev, :next)} = :nearest

    mode :: Model.EnumType{(:mouse, :vline, :hline)} = :mouse

    muted_policy :: Model.EnumType{(:ignore, :show)} = :show

    names :: Vector{String} = String[]

    point_policy :: Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    renderers :: Union{Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    show_arrow :: Bool = true

    toggleable :: Bool = true

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = [("index", "\$index"), ("data (x, y)", "(\$x, \$y)"), ("screen (x, y)", "(\$sx, \$sy)")]
end
