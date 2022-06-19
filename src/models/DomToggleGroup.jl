#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDomToggleGroup, Bokeh.Models.CustomJS, Bokeh.Models.RendererGroup

@model mutable struct DomToggleGroup <: iDomToggleGroup

    syncable :: Bool = true

    groups :: Vector{<:iRendererGroup}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
