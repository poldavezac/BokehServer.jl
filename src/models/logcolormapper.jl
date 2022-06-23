#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LogColorMapper <: iLogColorMapper

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}} = Tuple{iGlyphRenderer, Union{String, Vector{String}}}[]

    high :: Model.Nullable{Float64} = nothing

    high_color :: Model.Nullable{Model.Color} = nothing

    low :: Model.Nullable{Float64} = nothing

    low_color :: Model.Nullable{Model.Color} = nothing

    nan_color :: Model.Color = "rgb(128,128,128)"

    palette :: Vector{Model.Color}
end
