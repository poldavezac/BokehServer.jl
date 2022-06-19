#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDataTable, Bokeh.Models.DataSource, Bokeh.Models.CustomJS, Bokeh.Models.CDSView, Bokeh.Models.TableColumn

@model mutable struct DataTable <: iDataTable

    syncable :: Bool = true

    frozen_rows :: Bokeh.Model.Nullable{Int64} = nothing

    index_position :: Bokeh.Model.Nullable{Int64} = 0

    scroll_to_selection :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    css_classes :: Vector{String} = String[]

    header_row :: Bool = true

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    columns :: Vector{<:iTableColumn}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    index_header :: String = "#"

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    auto_edit :: Bool = false

    fit_columns :: Bokeh.Model.Nullable{Bool} = nothing

    index_width :: Int64 = 40

    row_height :: Int64 = 25

    sortable :: Bool = true

    subscribed_events :: Vector{Symbol}

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    selectable :: Union{Bool, Bokeh.Model.EnumType{(:checkbox,)}} = true

    autosize_mode :: Bokeh.Model.EnumType{(:none, :fit_columns, :fit_viewport, :force_fit)} = :force_fit

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    editable :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    reorderable :: Bool = true

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    view :: iCDSView

    frozen_columns :: Bokeh.Model.Nullable{Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    source :: iDataSource = ColumnDataSource()

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end
