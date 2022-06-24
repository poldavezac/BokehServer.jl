#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LegendItem <: iLegendItem

    index :: Model.Nullable{Int64} = nothing

    label :: Model.NullStringSpec = nothing

    renderers :: Vector{iGlyphRenderer} = iGlyphRenderer[]

    visible :: Bool = true
end
