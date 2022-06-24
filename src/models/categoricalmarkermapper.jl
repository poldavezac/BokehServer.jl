#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CategoricalMarkerMapper <: iCategoricalMarkerMapper

    default_value :: Model.MarkerType = :circle

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Model.Nullable{Int64} = nothing

    markers :: Vector{Model.MarkerType}

    start :: Int64 = 0
end
