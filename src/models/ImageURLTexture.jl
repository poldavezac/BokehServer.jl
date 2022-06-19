#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iImageURLTexture, Bokeh.Models.CustomJS

@model mutable struct ImageURLTexture <: iImageURLTexture

    syncable :: Bool = true

    url :: String

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
