#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DOMTemplate <: iDOMTemplate

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    actions :: Vector{iAction}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end
