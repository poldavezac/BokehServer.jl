#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CategoricalPatternMapper <: iCategoricalPatternMapper

    default_value :: Model.HatchPatternType = :blank

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Model.Nullable{Int64} = nothing

    patterns :: Vector{Model.HatchPatternType}

    start :: Int64 = 0
end
