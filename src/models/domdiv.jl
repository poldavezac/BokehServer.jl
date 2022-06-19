#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DOMDiv <: iDOMDiv

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end
