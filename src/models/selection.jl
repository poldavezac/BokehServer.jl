#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Selection <: iSelection

    indices :: Vector{Int64} = Int64[]

    line_indices :: Vector{Int64} = Int64[]

    multiline_indices :: Dict{String, Vector{Int64}}
end
