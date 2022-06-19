#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct EditTool <: iEditTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
