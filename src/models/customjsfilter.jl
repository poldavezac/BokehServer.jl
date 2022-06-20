#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CustomJSFilter <: iCustomJSFilter

    args :: Dict{Model.RestrictedKey{(:source,)}, Any}

    code :: String = ""
end
