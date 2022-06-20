#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LineEditTool <: iLineEditTool

    custom_icon :: Model.Nullable{Model.Image} = nothing

    description :: Model.Nullable{String} = nothing

    dimensions :: Model.EnumType{(:width, :height, :both)} = :both

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String}

    intersection_renderer :: iGlyphRenderer

    renderers :: Vector{iGlyphRenderer}
end
