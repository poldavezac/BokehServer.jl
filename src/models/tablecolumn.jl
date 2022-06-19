#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TableColumn <: iTableColumn

    syncable :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    default_sort :: Bokeh.Model.EnumType{(:ascending, :descending)} = :ascending

    sortable :: Bool = true

    title :: Bokeh.Model.Nullable{String} = nothing

    formatter :: iCellFormatter = StringFormatter()

    subscribed_events :: Vector{Symbol}

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    editor :: iCellEditor = StringEditor()

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width :: Int64 = 300
end
