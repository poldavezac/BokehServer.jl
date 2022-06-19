#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iToolbarBase, Bokeh.Models.CustomJS, Bokeh.Models.Tool

@model mutable struct ToolbarBase <: iToolbarBase

    syncable :: Bool = true

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    tools :: Vector{<:iTool}

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
