#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStep, Bokeh.Models.CustomJS

@model mutable struct Step <: iStep

    syncable :: Bool = true

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :before

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    line_dash_offset :: Int64 = 0

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    line_dash :: Bokeh.Model.DashPattern
end
