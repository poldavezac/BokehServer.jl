#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iProxyToolbar, Bokeh.Models.CustomJS, Bokeh.Models.Toolbar, Bokeh.Models.Tool

@model mutable struct ProxyToolbar <: iProxyToolbar

    syncable :: Bool = true

    tools :: Vector{<:iTool}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    subscribed_events :: Vector{Symbol}

    toolbars :: Vector{<:iToolbar}

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
