#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iPolarTransform, Bokeh.Models.CustomJS

@model mutable struct PolarTransform <: iPolarTransform

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "angle",)

    name :: Bokeh.Model.Nullable{String} = nothing

    radius :: Bokeh.Model.Spec{Float64} = (field = "radius",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock
end
