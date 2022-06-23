#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@wrap mutable struct FigureOptions <: iHasProps

    active_drag :: Union{Nothing, iDrag, String, Model.EnumType{(:auto,)}} = :auto

    active_inspect :: Union{Nothing, iInspectTool, String, Model.EnumType{(:auto,)}, Vector{iInspectTool}} = :auto

    active_multi :: Union{Nothing, iGestureTool, String, Model.EnumType{(:auto,)}} = :auto

    active_scroll :: Union{Nothing, iScroll, String, Model.EnumType{(:auto,)}} = :auto

    active_tap :: Union{Nothing, iTap, String, Model.EnumType{(:auto,)}} = :auto

    tools :: Union{String, Vector{Union{iTool, String}}} = "pan,wheel_zoom,box_zoom,save,reset,help"

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = nothing

    x_axis_label :: Model.Nullable{Union{iBaseText, String}} = ""

    x_axis_location :: Model.Nullable{Model.EnumType{(:above, :below)}} = :below

    x_axis_type :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto

    x_minor_ticks :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    x_range :: Any = nothing

    y_axis_label :: Model.Nullable{Union{iBaseText, String}} = ""

    y_axis_location :: Model.Nullable{Model.EnumType{(:left, :right)}} = :left

    y_axis_type :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto

    y_minor_ticks :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    y_range :: Any = nothing
end
