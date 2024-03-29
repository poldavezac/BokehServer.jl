#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct FreehandDrawTool <: iFreehandDrawTool

    description :: Union{Nothing, String} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String} = required

    icon :: Union{Nothing, Model.ToolIconValue} = nothing

    num_objects :: Int64 = 0

    renderers :: Vector{iGlyphRenderer} = iGlyphRenderer[]
end
export FreehandDrawTool
