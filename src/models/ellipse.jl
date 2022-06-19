#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Ellipse <: iEllipse

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    height :: Bokeh.Model.DistanceSpec = (field = "height",)

    height_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    width :: Bokeh.Model.DistanceSpec = (field = "width",)

    width_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)
end
