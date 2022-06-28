#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Arrow <: iArrow

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    finish :: Model.Nullable{iArrowHead} = OpenHead()

    finish_units :: Model.EnumType{(:screen, :data)} = :data

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.AlphaSpec = 1.0

    line_cap :: Model.LineCapSpec = :butt

    line_color :: Model.ColorSpec = "black"

    line_dash :: Model.DashPatternSpec = Int64[]

    line_dash_offset :: Model.IntSpec = 0

    line_join :: Model.LineJoinSpec = :bevel

    line_width :: Model.NumberSpec = 1.0

    source :: iDataSource = ColumnDataSource()

    start :: Model.Nullable{iArrowHead} = nothing

    start_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_end :: Model.NumberSpec = "x_end"

    x_range_name :: String = "default"

    x_start :: Model.NumberSpec = "x_start"

    y_end :: Model.NumberSpec = "y_end"

    y_range_name :: String = "default"

    y_start :: Model.NumberSpec = "y_start"
end
