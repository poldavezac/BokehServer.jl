#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Whisker <: iWhisker

    base :: Model.PropertyUnitsSpec = (field = "base", units = :data)

    base_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Model.EnumType{(:width, :height)} = :height

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :underlay

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.LineCapSpec = (value = :butt,)

    line_color :: Model.ColorSpec = (value = "rgb(0,0,0)",)

    line_dash :: Model.DashPatternSpec = (value = Int64[],)

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.LineJoinSpec = (value = :bevel,)

    line_width :: Model.NumberSpec = (value = 1.0,)

    lower :: Model.PropertyUnitsSpec = (field = "lower", units = :data)

    lower_head :: Model.Nullable{iArrowHead} = TeeHead()

    lower_units :: Model.EnumType{(:screen, :data)} = :data

    source :: iDataSource = ColumnDataSource()

    upper :: Model.PropertyUnitsSpec = (field = "upper", units = :data)

    upper_head :: Model.Nullable{iArrowHead} = TeeHead()

    upper_units :: Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
