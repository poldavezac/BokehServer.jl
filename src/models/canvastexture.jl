#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CanvasTexture <: iCanvasTexture

    syncable :: Bool = true

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    code :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
