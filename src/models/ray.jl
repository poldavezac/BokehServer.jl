#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Ray <: iRay

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    length_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    length :: Bokeh.Model.DistanceSpec = (value = 0.0,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
