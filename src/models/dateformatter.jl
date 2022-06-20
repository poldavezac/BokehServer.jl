#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DateFormatter <: iDateFormatter

    font_style :: Model.EnumType{(:normal, :italic, :bold, Symbol("bold italic"))} = :normal

    format :: Union{String, Model.EnumType{(:ATOM, :W3C, Symbol("RFC-3339"), Symbol("ISO-8601"), :COOKIE, Symbol("RFC-822"), Symbol("RFC-850"), Symbol("RFC-1036"), Symbol("RFC-1123"), Symbol("RFC-2822"), :RSS, :TIMESTAMP)}} = Symbol("ISO-8601")

    nan_format :: String = "-"

    text_align :: Model.EnumType{(:left, :right, :center)} = :left

    text_color :: Model.Nullable{Model.Color} = nothing
end
