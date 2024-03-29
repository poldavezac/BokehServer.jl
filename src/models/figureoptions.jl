#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@wrap mutable struct FigureOptions <: iHasProps

    active_drag :: Union{Nothing, iDrag, String, Model.EnumType{(:auto,)}} = :auto

    active_inspect :: Union{Nothing, iInspectTool, String, Model.EnumType{(:auto,)}, Vector{iInspectTool}} = :auto

    active_multi :: Union{Nothing, iGestureTool, String, Model.EnumType{(:auto,)}} = :auto

    active_scroll :: Union{Nothing, iScroll, String, Model.EnumType{(:auto,)}} = :auto

    active_tap :: Union{Nothing, iTap, String, Model.EnumType{(:auto,)}} = :auto

    tools :: Union{String, Vector{Union{iTool, String}}} = "pan,wheel_zoom,box_zoom,save,reset,help"

    tooltips :: Union{Nothing, iDOMTemplate, String, Vector{Tuple{String, String}}} = nothing

    x_axis_label :: Union{Nothing, iBaseText, String} = ""

    x_axis_location :: Union{Nothing, Model.VerticalLocation} = :below

    x_axis_type :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto

    x_minor_ticks :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    x_range :: Any = nothing

    y_axis_label :: Union{Nothing, iBaseText, String} = ""

    y_axis_location :: Union{Nothing, Model.HorizontalLocation} = :left

    y_axis_type :: Union{Nothing, Model.EnumType{(:auto, :linear, :log, :datetime, :mercator)}} = :auto

    y_minor_ticks :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    y_range :: Any = nothing
end
export FigureOptions
