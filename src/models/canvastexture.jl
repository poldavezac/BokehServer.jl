#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CanvasTexture <: iCanvasTexture

    code :: String

    repetition :: Model.EnumType{(:repeat, :repeat_x, :repeat_y, :no_repeat)} = :repeat
end
