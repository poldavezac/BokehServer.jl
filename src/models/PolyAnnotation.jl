#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iPolyAnnotation, Bokeh.Models.Texture, Bokeh.Models.CustomJS

@model mutable struct PolyAnnotation <: iPolyAnnotation

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    ys :: Vector{Float64} = Float64[]

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    ys_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    line_width :: Float64 = 1.0

    x_range_name :: String = "default"

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    hatch_weight :: Bokeh.Model.Size = 1.0

    xs :: Vector{Float64} = Float64[]

    xs_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
