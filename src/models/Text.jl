#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iText, Bokeh.Models.CustomJS

@model mutable struct Text <: iText

    syncable :: Bool = true

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text :: Bokeh.Model.Spec{String} = Bokeh.Model.Unknown()

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    name :: Bokeh.Model.Nullable{String} = nothing

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
