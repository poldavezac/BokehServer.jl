#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Arrow <: iArrow

    syncable :: Bool = true

    start_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    visible :: Bool = true

    start :: Bokeh.Model.Nullable{iArrowHead} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish :: Bokeh.Model.Nullable{iArrowHead} = OpenHead()

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    y_end :: Bokeh.Model.Spec{Float64} = (field = "y_end",)

    finish_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    x_start :: Bokeh.Model.Spec{Float64} = (field = "x_start",)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    y_start :: Bokeh.Model.Spec{Float64} = (field = "y_start",)

    x_end :: Bokeh.Model.Spec{Float64} = (field = "x_end",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()
end
