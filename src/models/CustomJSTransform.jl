#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCustomJSTransform, Bokeh.Models.CustomJS

@model mutable struct CustomJSTransform <: iCustomJSTransform

    syncable :: Bool = true

    v_func :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    args :: Dict{String, Any}

    func :: String = ""

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
