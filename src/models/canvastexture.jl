#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CanvasTexture <: iCanvasTexture

    code :: String

    repetition :: Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat
end
