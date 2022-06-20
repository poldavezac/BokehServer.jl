#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HoverTool <: iHoverTool

    anchor :: Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)} = :center

    attachment :: Model.EnumType{(:horizontal, :vertical, :left, :right, :above, :below)} = :horizontal

    callback :: Model.Nullable{iCallback} = nothing

    description :: Model.Nullable{String} = nothing

    formatters :: Dict{String, Union{iCustomJSHover, Model.EnumType{(:numeral, :datetime, :printf)}}}

    line_policy :: Model.EnumType{(:prev, :next, :nearest, :interp, :none)} = :nearest

    mode :: Model.EnumType{(:mouse, :hline, :vline)} = :mouse

    muted_policy :: Model.EnumType{(:show, :ignore)} = :show

    names :: Vector{String} = String[]

    point_policy :: Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    renderers :: Union{Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    show_arrow :: Bool = true

    toggleable :: Bool = true

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = [("index", "\$index"), ("data (x, y)", "(\$x, \$y)"), ("screen (x, y)", "(\$sx, \$sy)")]
end
