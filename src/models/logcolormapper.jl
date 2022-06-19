#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LogColorMapper <: iLogColorMapper

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    high :: Bokeh.Model.Nullable{Float64} = nothing

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    palette :: Vector{Bokeh.Model.Color}

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
