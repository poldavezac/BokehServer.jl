#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct StringFormatter <: iStringFormatter

    font_style :: Model.FontStyle = :normal

    nan_format :: String = "-"

    text_align :: Model.TextAlign = :left

    text_color :: Model.Nullable{Model.Color} = nothing
end
