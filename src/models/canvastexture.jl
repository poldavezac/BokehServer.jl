#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct CanvasTexture <: iCanvasTexture

    code :: String = required

    repetition :: Model.EnumType{(:repeat, :repeat_x, :repeat_y, :no_repeat)} = :repeat
end
export CanvasTexture
