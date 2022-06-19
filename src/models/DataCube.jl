#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDataCube, Bokeh.Models.DataSource, Bokeh.Models.GroupingInfo, Bokeh.Models.CustomJS, Bokeh.Models.CDSView, Bokeh.Models.TableColumn

@model mutable struct DataCube <: iDataCube

    syncable :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    fit_columns :: Bokeh.Model.Nullable{Bool} = nothing

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    target :: iDataSource

    view :: iCDSView

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    columns :: Vector{<:iTableColumn}

    index_header :: String = "#"

    sortable :: Bool = true

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    source :: iDataSource = ColumnDataSource()

    frozen_rows :: Bokeh.Model.Nullable{Int64} = nothing

    index_position :: Bokeh.Model.Nullable{Int64} = 0

    css_classes :: Vector{String} = String[]

    header_row :: Bool = true

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    row_height :: Int64 = 25

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    auto_edit :: Bool = false

    subscribed_events :: Vector{Symbol}

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    selectable :: Union{Bool, Bokeh.Model.EnumType{(:checkbox,)}} = true

    editable :: Bool = false

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    frozen_columns :: Bokeh.Model.Nullable{Int64} = nothing

    grouping :: Vector{<:iGroupingInfo}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    scroll_to_selection :: Bool = true

    disabled :: Bool = false

    index_width :: Int64 = 40

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    autosize_mode :: Bokeh.Model.EnumType{(:none, :fit_columns, :fit_viewport, :force_fit)} = :force_fit

    reorderable :: Bool = true
end
