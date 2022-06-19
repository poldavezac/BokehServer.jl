#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Toolbar <: iToolbar

    active_drag :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, iDrag} = Bokeh.Model.Unknown()

    active_inspect :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, iInspectTool, Vector{iInspectTool}} = Bokeh.Model.Unknown()

    active_multi :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, iGestureTool} = Bokeh.Model.Unknown()

    active_scroll :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, iScroll} = Bokeh.Model.Unknown()

    active_tap :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, iTap} = Bokeh.Model.Unknown()

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
