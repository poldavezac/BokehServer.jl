#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct VBox <: iVBox

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:auto, :start, :center, :end)}} = :auto

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    children :: Vector{NamedTuple{(:child, :row, :span), Tuple{iUIElement, Int64, Int64}}} = NamedTuple{(:child, :row, :span), Tuple{iUIElement, Int64, Int64}}[]

    classes :: Vector{String} = String[]

    context_menu :: Union{Nothing, iMenu} = nothing

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    flow_mode :: Model.EnumType{(:block, :inline)} = :block

    height :: Union{Nothing, Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    margin :: Union{Nothing, Int64, Tuple{Int64, Int64}, NTuple{4, Int64}} = nothing

    max_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    max_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    resizable :: Union{Bool, Model.EnumType{(:width, :height, :both)}} = false

    rows :: Any = nothing

    sizing_mode :: Union{Nothing, Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    spacing :: Union{Int64, Tuple{Int64, Int64}} = 0

    styles :: Union{iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()

    stylesheets :: Vector{Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}} = Union{Dict{String, Union{iStyles, Dict{String, Union{Nothing, String}}}}, String}[]

    visible :: Bool = true

    width :: Union{Nothing, Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
export VBox
