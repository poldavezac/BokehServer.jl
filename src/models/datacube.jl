#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DataCube <: iDataCube

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    auto_edit :: Bool = false

    autosize_mode :: Model.EnumType{(:fit_columns, :fit_viewport, :force_fit, :none)} = :force_fit

    background :: Model.Nullable{Model.Color} = nothing

    columns :: Vector{iTableColumn} = iTableColumn[]

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    editable :: Bool = false

    fit_columns :: Model.Nullable{Bool} = nothing

    frozen_columns :: Model.Nullable{Int64} = nothing

    frozen_rows :: Model.Nullable{Int64} = nothing

    grouping :: Vector{iGroupingInfo} = iGroupingInfo[]

    header_row :: Bool = true

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    index_header :: String = "#"

    index_position :: Model.Nullable{Int64} = 0

    index_width :: Int64 = 40

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    reorderable :: Bool = true

    row_height :: Int64 = 25

    scroll_to_selection :: Bool = true

    selectable :: Union{Bool, Model.EnumType{(:checkbox,)}} = true

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    sortable :: Bool = true

    source :: iDataSource = ColumnDataSource()

    target :: iDataSource

    view :: iCDSView

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
