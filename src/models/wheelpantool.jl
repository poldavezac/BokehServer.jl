#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct WheelPanTool <: iWheelPanTool

    description :: Union{Nothing, String} = nothing

    dimension :: Model.EnumType{(:width, :height)} = :width

    icon :: Union{Nothing, Model.ToolIconValue} = nothing
end
export WheelPanTool
