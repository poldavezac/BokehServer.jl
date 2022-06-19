#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DataTable <: iDataTable

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    auto_edit :: Bool = false

    autosize_mode :: Bokeh.Model.EnumType{(:none, :fit_columns, :fit_viewport, :force_fit)} = :force_fit

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    columns :: Vector{iTableColumn}

    css_classes :: Vector{String} = String[]

    default_size :: Int64 = 300

    disabled :: Bool = false

    editable :: Bool = false

    fit_columns :: Bokeh.Model.Nullable{Bool} = nothing

    frozen_columns :: Bokeh.Model.Nullable{Int64} = nothing

    frozen_rows :: Bokeh.Model.Nullable{Int64} = nothing

    header_row :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    index_header :: String = "#"

    index_position :: Bokeh.Model.Nullable{Int64} = 0

    index_width :: Int64 = 40

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    reorderable :: Bool = true

    row_height :: Int64 = 25

    scroll_to_selection :: Bool = true

    selectable :: Union{Bool, Bokeh.Model.EnumType{(:checkbox,)}} = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    sortable :: Bool = true

    source :: iDataSource = ColumnDataSource()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    view :: iCDSView

    visible :: Bool = true

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto
end
