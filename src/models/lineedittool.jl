#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct LineEditTool <: iLineEditTool

    description :: Union{Nothing, String} = nothing

    dimensions :: Model.EnumType{(:width, :height, :both)} = :both

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String} = required

    icon :: Union{Nothing, Model.ToolIconValue} = nothing

    intersection_renderer :: iGlyphRenderer

    renderers :: Vector{iGlyphRenderer} = iGlyphRenderer[]
end
export LineEditTool
