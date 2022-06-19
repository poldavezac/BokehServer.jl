#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LineEditTool <: iLineEditTool

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    intersection_renderer :: iGlyphRenderer

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end