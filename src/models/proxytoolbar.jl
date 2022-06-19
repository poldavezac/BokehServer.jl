#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ProxyToolbar <: iProxyToolbar

    syncable :: Bool = true

    tools :: Vector{iTool}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    subscribed_events :: Vector{Symbol}

    toolbars :: Vector{iToolbar}

    autohide :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
