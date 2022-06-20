#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct StringEditor <: iStringEditor

    completions :: Vector{String} = String[]
end
