#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iTexture, Bokeh.Models.CustomJS

@model mutable struct Texture <: iTexture

    syncable :: Bool = true

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
