#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct PolarTransform <: iPolarTransform

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "angle",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    radius :: Bokeh.Model.Spec{Float64} = (field = "radius",)

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
