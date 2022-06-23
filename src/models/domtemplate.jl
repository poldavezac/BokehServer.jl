#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DOMTemplate <: iDOMTemplate

    actions :: Vector{iAction} = iAction[]

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}} = Union{iDOMNode, iLayoutDOM, String}[]

    style :: Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end
