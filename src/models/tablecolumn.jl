#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TableColumn <: iTableColumn

    default_sort :: Model.EnumType{(:ascending, :descending)} = :ascending

    editor :: iCellEditor = StringEditor()

    field :: String

    formatter :: iCellFormatter = StringFormatter()

    sortable :: Bool = true

    title :: Model.Nullable{String} = nothing

    visible :: Bool = true

    width :: Int64 = 300
end
