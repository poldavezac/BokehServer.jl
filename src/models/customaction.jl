#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct CustomAction <: iCustomAction

    callback :: Union{Nothing, iCallback} = nothing

    description :: Union{Nothing, String} = "Perform a Custom Action"

    icon :: Union{Nothing, Model.ToolIconValue} = nothing
end
export CustomAction
