#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LabelSet <: iLabelSet

    syncable :: Bool = true

    source :: iDataSource = ColumnDataSource()

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    border_line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    visible :: Bool = true

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    text :: Bokeh.Model.Spec{String} = (field = "text",)

    tags :: Vector{Any}

    border_line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    background_fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{Symbol}

    background_fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    name :: Bokeh.Model.Nullable{String} = nothing

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    border_line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    border_line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    border_line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    border_line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    border_line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}
end
