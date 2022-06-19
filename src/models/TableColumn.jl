#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iTableColumn, Bokeh.Models.CustomJS, Bokeh.Models.CellFormatter, Bokeh.Models.CellEditor

@model mutable struct TableColumn <: iTableColumn

    syncable :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    default_sort :: Bokeh.Model.EnumType{(:ascending, :descending)} = :ascending

    sortable :: Bool = true

    title :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    formatter :: iCellFormatter = StringFormatter()

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    editor :: iCellEditor = StringEditor()

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    width :: Int64 = 300
end
