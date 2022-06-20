#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct PointDrawTool <: iPointDrawTool

    add :: Bool = true

    custom_icon :: Model.Nullable{Model.Image} = nothing

    description :: Model.Nullable{String} = nothing

    drag :: Bool = true

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Model.Color, String}

    num_objects :: Int64 = 0

    renderers :: Vector{iGlyphRenderer}
end
