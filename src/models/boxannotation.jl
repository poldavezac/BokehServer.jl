#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BoxAnnotation <: iBoxAnnotation

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    left :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    top :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    right_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    left_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    subscribed_events :: Vector{Symbol}

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    bottom_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    right :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    line_width :: Float64 = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    bottom :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_dash_offset :: Int64 = 0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    hatch_weight :: Bokeh.Model.Size = 1.0

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.DashPattern

    top_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end
