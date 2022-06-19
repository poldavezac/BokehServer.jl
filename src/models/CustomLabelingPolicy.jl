#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCustomLabelingPolicy, Bokeh.Models.CustomJS

@model mutable struct CustomLabelingPolicy <: iCustomLabelingPolicy

    syncable :: Bool = true

    code :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    args :: Dict{String, Any}

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
