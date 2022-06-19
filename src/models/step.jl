#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Step <: iStep

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    line_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    line_dash :: Bokeh.Model.DashPattern

    line_dash_offset :: Int64 = 0

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    line_width :: Float64 = 1.0

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :before

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)
end
