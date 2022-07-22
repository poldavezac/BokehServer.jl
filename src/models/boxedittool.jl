#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct BoxEditTool <: iBoxEditTool

    custom_icon :: Union{Nothing, Model.Image} = nothing

    description :: Union{Nothing, String} = nothing

    dimensions :: Model.EnumType{(:width, :height, :both)} = :both

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String}

    num_objects :: Int64 = 0

    renderers :: Vector{iGlyphRenderer} = iGlyphRenderer[]
end
export BoxEditTool
