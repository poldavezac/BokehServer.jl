#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Slope <: iSlope

    syncable :: Bool = true

    gradient :: Bokeh.Model.Nullable{Float64} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    y_intercept :: Bokeh.Model.Nullable{Float64} = nothing

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    line_width :: Float64 = 1.0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    line_dash_offset :: Int64 = 0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
