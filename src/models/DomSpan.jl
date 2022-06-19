#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDomSpan, Bokeh.Models.DomDOMNode, Bokeh.Models.CustomJS, Bokeh.Models.LayoutDOM

@model mutable struct DomSpan <: iDomSpan

    syncable :: Bool = true

    children :: Vector{Union{<:iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{<:iStyles, Dict{String, String}}} = nothing
end
