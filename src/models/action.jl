#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct Action <: iUIAction

    classes :: Vector{String} = String[]

    description :: Union{Nothing, String} = nothing

    icon :: Union{Nothing, iIcon} = nothing

    label :: String = required

    menu :: Union{Nothing, iMenu} = nothing

    styles :: Union{iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()

    stylesheets :: Vector{Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}} = Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}[]

    visible :: Bool = true
end
export Action
