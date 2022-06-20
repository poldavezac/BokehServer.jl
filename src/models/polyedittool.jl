#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PolyEditTool <: iPolyEditTool

    custom_icon :: Model.Nullable{Model.Image} = nothing

    description :: Model.Nullable{String} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String}

    renderers :: Vector{iGlyphRenderer}

    vertex_renderer :: Model.Nullable{iGlyphRenderer} = nothing
end
