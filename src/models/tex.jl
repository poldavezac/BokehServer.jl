#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TeX <: iTeX

    inline :: Bool = false

    macros :: Dict{String, Union{String, Tuple{String, Int64}}} = Dict{String, Union{String, Tuple{String, Int64}}}()

    text :: String
end
