#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct DOMTemplate <: iDOMTemplate

    actions :: Vector{iDOMAction} = iDOMAction[]

    children :: Vector{Union{iDOMNode, iUIElement, String}} = Union{iDOMNode, iUIElement, String}[]

    style :: Union{Nothing, iStyles, Dict{String, String}} = nothing
end
export DOMTemplate
