#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct PolyAnnotation <: iPolyAnnotation

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    fill_alpha :: Bokeh.Model.Percent = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_weight :: Bokeh.Model.Size = 1.0

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    line_dash :: Bokeh.Model.DashPattern

    line_dash_offset :: Int64 = 0

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true

    x_range_name :: String = "default"

    xs :: Vector{Float64} = Float64[]

    xs_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y_range_name :: String = "default"

    ys :: Vector{Float64} = Float64[]

    ys_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end
