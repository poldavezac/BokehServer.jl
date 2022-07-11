#- file generated by BokehJL's 'CodeCreator': edit at your own risk! -#

@model mutable struct Grid <: iGrid

    axis :: Union{Nothing, iAxis} = nothing

    band_fill_alpha :: Model.Percent = 0.0

    band_fill_color :: Union{Nothing, Model.Color} = nothing

    band_hatch_alpha :: Model.Percent = 1.0

    band_hatch_color :: Union{Nothing, Model.Color} = "#000000"

    band_hatch_extra :: Dict{String, iTexture} = Dict{String, iTexture}()

    band_hatch_pattern :: Union{Nothing, String} = nothing

    band_hatch_scale :: Model.Size = 12.0

    band_hatch_weight :: Model.Size = 1.0

    bounds :: Union{Tuple{Float64, Float64}, Model.EnumType{(:auto,)}} = :auto

    coordinates :: Union{Nothing, iCoordinateMapping} = nothing

    dimension :: Int64 = 0

    grid_line_alpha :: Model.Percent = 1.0

    grid_line_cap :: Model.LineCap = :butt

    grid_line_color :: Union{Nothing, Model.Color} = "#E5E5E5"

    grid_line_dash :: Model.DashPattern = Int64[]

    grid_line_dash_offset :: Int64 = 0

    grid_line_join :: Model.LineJoin = :bevel

    grid_line_width :: Float64 = 1.0

    group :: Union{Nothing, iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :underlay

    minor_grid_line_alpha :: Model.Percent = 1.0

    minor_grid_line_cap :: Model.LineCap = :butt

    minor_grid_line_color :: Union{Nothing, Model.Color} = nothing

    minor_grid_line_dash :: Model.DashPattern = Int64[]

    minor_grid_line_dash_offset :: Int64 = 0

    minor_grid_line_join :: Model.LineJoin = :bevel

    minor_grid_line_width :: Float64 = 1.0

    ticker :: Union{Nothing, iTicker} = nothing

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
