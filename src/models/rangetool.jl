#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct RangeTool <: iRangeTool

    description :: Union{Nothing, String} = nothing

    icon :: Union{Nothing, Model.ToolIconValue} = nothing

    overlay :: iBoxAnnotation = BoxAnnotation(line_width = 0.5, line_color = "black", syncable = false, fill_alpha = 0.5, line_alpha = 1.0, fill_color = "lightgrey", line_dash = Any[2, 2], level = "overlay")

    x_interaction :: Bool = true

    x_range :: Union{Nothing, iRange1d} = nothing

    y_interaction :: Bool = true

    y_range :: Union{Nothing, iRange1d} = nothing
end
export RangeTool
