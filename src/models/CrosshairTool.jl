#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCrosshairTool, Bokeh.Models.CustomJS

@model mutable struct CrosshairTool <: iCrosshairTool

    syncable :: Bool = true

    line_color :: Bokeh.Model.Color = "rgb(0,0,0)"

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    toggleable :: Bool = true

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
