#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct StaticLayoutProvider <: iStaticLayoutProvider

    graph_layout :: Dict{Union{Int64, String}, Vector{Any}}
end
