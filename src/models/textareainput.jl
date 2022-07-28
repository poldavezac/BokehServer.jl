#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct TextAreaInput <: iTextAreaInput

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:auto, :start, :center, :end)}} = :auto

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    classes :: Vector{String} = String[]

    cols :: Int64 = 20

    context_menu :: Union{Nothing, iMenu} = nothing

    css_classes :: Vector{String} = String[]

    description :: Union{Nothing, iTooltip, String} = nothing

    disabled :: Bool = false

    flow_mode :: Model.EnumType{(:block, :inline)} = :block

    height :: Union{Nothing, Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Union{Nothing, Int64, Tuple{Int64, Int64}, NTuple{4, Int64}} = nothing

    max_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    max_length :: Union{Nothing, Int64} = 500

    max_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    placeholder :: String = ""

    resizable :: Union{Bool, Model.EnumType{(:width, :height, :both)}} = false

    rows :: Int64 = 2

    sizing_mode :: Union{Nothing, Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    styles :: Union{iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()

    stylesheets :: Vector{Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}} = Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}[]

    title :: String = ""

    value :: String = ""

    value_input :: String = ""

    visible :: Bool = true

    width :: Union{Nothing, Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
export TextAreaInput
