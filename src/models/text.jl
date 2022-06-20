#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct Text <: iText

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text :: Bokeh.Model.Spec{String} = Bokeh.Model.Unknown()

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)
end
