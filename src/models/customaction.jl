#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CustomAction <: iCustomAction

    callback :: Model.Nullable{iCallback} = nothing

    description :: Model.Nullable{String} = "Perform a Custom Action"

    icon :: Model.Image
end
