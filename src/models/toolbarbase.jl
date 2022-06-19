#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ToolbarBase <: iToolbarBase

    autohide :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    tools :: Vector{iTool}
end
