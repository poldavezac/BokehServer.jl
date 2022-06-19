#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LabelSet <: iLabelSet

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    background_fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    background_fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    border_line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    border_line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    border_line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    border_line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    border_line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    border_line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    border_line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    name :: Bokeh.Model.Nullable{String} = nothing

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    source :: iDataSource = ColumnDataSource()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text :: Bokeh.Model.Spec{String} = (field = "text",)

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    visible :: Bool = true

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    x_range_name :: String = "default"

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y_range_name :: String = "default"

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end
