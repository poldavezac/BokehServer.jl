#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Grid <: iGrid

    axis :: Model.Nullable{iAxis} = nothing

    band_fill_alpha :: Model.Percent = 0.0

    band_fill_color :: Model.Nullable{Model.Color} = nothing

    band_hatch_alpha :: Model.Percent = 1.0

    band_hatch_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    band_hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    band_hatch_pattern :: Model.Nullable{String} = nothing

    band_hatch_scale :: Model.Size = 12.0

    band_hatch_weight :: Model.Size = 1.0

    bounds :: Union{Tuple{Float64, Float64}, Model.EnumType{(:auto,)}} = :auto

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Int64 = 0

    grid_line_alpha :: Model.Percent = 1.0

    grid_line_cap :: Model.LineCap = :butt

    grid_line_color :: Model.Nullable{Model.Color} = "rgb(229,229,229)"

    grid_line_dash :: Model.DashPattern = Int64[]

    grid_line_dash_offset :: Int64 = 0

    grid_line_join :: Model.LineJoin = :bevel

    grid_line_width :: Float64 = 1.0

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :underlay

    minor_grid_line_alpha :: Model.Percent = 1.0

    minor_grid_line_cap :: Model.LineCap = :butt

    minor_grid_line_color :: Model.Nullable{Model.Color} = nothing

    minor_grid_line_dash :: Model.DashPattern = Int64[]

    minor_grid_line_dash_offset :: Int64 = 0

    minor_grid_line_join :: Model.LineJoin = :bevel

    minor_grid_line_width :: Float64 = 1.0

    ticker :: Model.Nullable{iTicker} = nothing

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
