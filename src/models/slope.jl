#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Slope <: iSlope

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    gradient :: Model.Nullable{Float64} = nothing

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    line_alpha :: Model.Percent = 1.0

    line_cap :: Model.EnumType{(:butt, :round, :square)} = :butt

    line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    line_dash :: Model.DashPattern = Int64[]

    line_dash_offset :: Int64 = 0

    line_join :: Model.EnumType{(:miter, :round, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    visible :: Bool = true

    x_range_name :: String = "default"

    y_intercept :: Model.Nullable{Float64} = nothing

    y_range_name :: String = "default"
end
