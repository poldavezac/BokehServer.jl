#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CustomJSTransform <: iCustomJSTransform

    args :: Dict{String, Any} = Dict{String, Any}()

    func :: String = ""

    v_func :: String = ""
end
