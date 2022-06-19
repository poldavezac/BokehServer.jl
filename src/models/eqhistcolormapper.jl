#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct EqHistColorMapper <: iEqHistColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    rescale_discrete_levels :: Bool = false

    subscribed_events :: Vector{Symbol}

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    bins :: Int64 = 65536

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
