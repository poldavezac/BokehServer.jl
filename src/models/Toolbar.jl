#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iToolbar, Bokeh.Models.Scroll, Bokeh.Models.InspectTool, Bokeh.Models.Tap, Bokeh.Models.GestureTool, Bokeh.Models.CustomJS, Bokeh.Models.Drag, Bokeh.Models.Tool

@model mutable struct Toolbar <: iToolbar

    syncable :: Bool = true

    active_scroll :: Union{Nothing, iScroll, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    tools :: Vector{<:iTool}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    active_drag :: Union{Nothing, iDrag, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    active_inspect :: Union{Nothing, iInspectTool, Bokeh.Model.EnumType{(:auto,)}, Vector{<:iInspectTool}} = Bokeh.Model.Unknown()

    active_multi :: Union{Nothing, iGestureTool, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    active_tap :: Union{Nothing, iTap, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()
end
