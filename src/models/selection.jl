#- file generated by BokehJL's 'CodeCreator': edit at your own risk! -#

@model mutable struct Selection <: iSelection

    indices :: Vector{Int64} = Int64[]

    line_indices :: Vector{Int64} = Int64[]

    multiline_indices :: Dict{String, Vector{Int64}} = Dict{String, Vector{Int64}}()
end
export Selection
