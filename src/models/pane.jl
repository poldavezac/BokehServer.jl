#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Pane <: iPane

    children :: Vector{Union{iUIElement, String}} = Union{iUIElement, String}[]

    classes :: Vector{String} = String[]

    styles :: Union{iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()

    stylesheets :: Vector{Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}} = Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}[]

    visible :: Bool = true
end
export Pane
