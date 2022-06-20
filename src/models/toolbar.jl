#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Toolbar <: iToolbar

    active_drag :: Union{Nothing, iDrag, Model.EnumType{(:auto,)}} = :auto

    active_inspect :: Union{Nothing, iInspectTool, Model.EnumType{(:auto,)}, Vector{iInspectTool}} = :auto

    active_multi :: Union{Nothing, iGestureTool, Model.EnumType{(:auto,)}} = :auto

    active_scroll :: Union{Nothing, iScroll, Model.EnumType{(:auto,)}} = :auto

    active_tap :: Union{Nothing, iTap, Model.EnumType{(:auto,)}} = :auto

    autohide :: Bool = false

    logo :: Model.Nullable{Model.EnumType{(:normal, :grey)}} = :normal

    tools :: Vector{iTool}
end
