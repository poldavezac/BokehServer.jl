#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct HelpTool <: iHelpTool

    description :: Union{Nothing, String} = "Click the question mark to learn more about Bokeh plot tools."

    icon :: Union{Nothing, Model.ToolIconValue} = nothing

    redirect :: String = "https://docs.bokeh.org/en/latest/docs/user_guide/tools.html"
end
export HelpTool
