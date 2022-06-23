#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Whisker <: iWhisker

    base :: Model.PropertyUnitsSpec = (field = "base", units = :data)

    base_units :: Model.EnumType{(:screen, :data)} = :data

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Model.EnumType{(:width, :height)} = :height

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.AlphaSpec = (value = 1.0,)

    line_cap :: Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Model.Spec{Model.Color} = (value = "rgb(0,0,0)",)

    line_dash :: Model.Spec{Model.DashPattern}

    line_dash_offset :: Model.Spec{Int64} = (value = 0,)

    line_join :: Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Model.Spec{Float64} = (value = 1.0,)

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
