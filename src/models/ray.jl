#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct Ray <: iRay

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    length :: Bokeh.Model.DistanceSpec = (value = 0.0,)

    length_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

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

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)
end
