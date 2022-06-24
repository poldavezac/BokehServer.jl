#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Tooltip <: iTooltip

    attachment :: Model.EnumType{(:horizontal, :vertical, :left, :right, :above, :below)} = :horizontal

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    inner_only :: Bool = true

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :overlay

    show_arrow :: Bool = true

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
