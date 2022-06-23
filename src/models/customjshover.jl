#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CustomJSHover <: iCustomJSHover

    args :: Dict{String, iModel} = Dict{String, iModel}()

    code :: String = ""
end
