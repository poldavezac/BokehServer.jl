#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Band <: iBand

    base :: Model.PropertyUnitsSpec = (field = "base", units = :data)

    base_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Model.EnumType{(:width, :height)} = :height

    fill_alpha :: Model.Percent = 0.4

    fill_color :: Model.Nullable{Model.Color} = "#FFF9BA"

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.Percent = 0.3

    line_cap :: Model.LineCap = :butt

    line_color :: Model.Nullable{Model.Color} = "#CCCCCC"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.LineJoin = :bevel

    line_width :: Float64 = 1.0

    lower :: Model.PropertyUnitsSpec = (field = "lower", units = :data)

    lower_units :: Model.EnumType{(:screen, :data)} = :data

    source :: iDataSource = ColumnDataSource()

    upper :: Model.PropertyUnitsSpec = (field = "upper", units = :data)

    upper_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
