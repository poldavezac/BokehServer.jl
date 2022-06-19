#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TableColumn <: iTableColumn

    default_sort :: Bokeh.Model.EnumType{(:ascending, :descending)} = :ascending

    editor :: iCellEditor = StringEditor()

    field :: String

    formatter :: iCellFormatter = StringFormatter()

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    sortable :: Bool = true

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: Bokeh.Model.Nullable{String} = nothing

    visible :: Bool = true

    width :: Int64 = 300
end
