#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Arc <: iArc

    start_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    finish_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    subscribed_events :: Vector{Symbol}

    start_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    finish_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    radius :: Bokeh.Model.DistanceSpec = (field = "radius",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
