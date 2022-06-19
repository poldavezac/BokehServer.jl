#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Circle <: iCircle

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    size :: Bokeh.Model.SizeSpec = (value = 4.0,)

    tags :: Vector{Any}

    radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hit_dilation :: Bokeh.Model.Size = 1.0

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    radius_dimension :: Bokeh.Model.EnumType{(:max, :min, :y, :x)} = :x

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    radius :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
