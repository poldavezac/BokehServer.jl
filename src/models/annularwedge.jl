#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AnnularWedge <: iAnnularWedge

    start_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    inner_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    finish_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    subscribed_events :: Vector{Symbol}

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    start_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    outer_radius :: Bokeh.Model.DistanceSpec = (field = "outer_radius",)

    outer_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    inner_radius :: Bokeh.Model.DistanceSpec = (field = "inner_radius",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}
end
