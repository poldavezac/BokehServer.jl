#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HelpTool <: iHelpTool

    description :: Model.Nullable{String} = "Click the question mark to learn more about Bokeh plot tools."

    redirect :: String = "https://docs.bokeh.org/en/latest/docs/user_guide/tools.html"
end
