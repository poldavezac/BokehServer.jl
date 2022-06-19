#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iWhisker, Bokeh.Models.DataSource, Bokeh.Models.CustomJS

@model mutable struct Whisker <: iWhisker

    syncable :: Bool = true

    upper_head :: Bokeh.Model.Nullable{<:iArrowHead} = TeeHead()

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    x_range_name :: String = "default"

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    lower_head :: Bokeh.Model.Nullable{<:iArrowHead} = TeeHead()

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    source :: iDataSource = ColumnDataSource()
end
