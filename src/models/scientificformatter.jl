#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ScientificFormatter <: iScientificFormatter

    font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    nan_format :: String = "-"

    power_limit_high :: Int64 = 5

    power_limit_low :: Int64 = -3

    precision :: Int64 = 10

    text_align :: Model.EnumType{(:left, :right, :center)} = :left

    text_color :: Model.Nullable{Model.Color} = nothing
end
