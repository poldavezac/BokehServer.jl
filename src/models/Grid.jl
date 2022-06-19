#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iGrid, Bokeh.Models.Texture, Bokeh.Models.CustomJS

@model mutable struct Grid <: iGrid

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    minor_grid_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    visible :: Bool = true

    grid_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis :: Bokeh.Model.Nullable{<:iAxis} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    band_hatch_alpha :: Bokeh.Model.Percent = 1.0

    grid_line_dash :: Bokeh.Model.DashPattern

    band_hatch_extra :: Dict{String, iTexture}

    band_hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    grid_line_alpha :: Bokeh.Model.Percent = 1.0

    band_hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    subscribed_events :: Vector{Symbol}

    band_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    band_hatch_weight :: Bokeh.Model.Size = 1.0

    grid_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_grid_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    grid_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    grid_line_dash_offset :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    band_hatch_scale :: Bokeh.Model.Size = 12.0

    minor_grid_line_dash :: Bokeh.Model.DashPattern

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    minor_grid_line_width :: Float64 = 1.0

    band_fill_alpha :: Bokeh.Model.Percent = 1.0

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    dimension :: Int64 = 0

    bounds :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    minor_grid_line_dash_offset :: Int64 = 0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    grid_line_width :: Float64 = 1.0

    minor_grid_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    ticker :: Bokeh.Model.Nullable{<:iTicker} = nothing

    minor_grid_line_alpha :: Bokeh.Model.Percent = 1.0

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
