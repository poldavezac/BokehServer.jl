#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ServerSentDataSource <: iServerSentDataSource

    adapter :: Model.Nullable{iCustomJS} = nothing

    data :: Model.DataDict

    data_url :: String

    max_size :: Model.Nullable{Int64} = nothing

    mode :: Model.EnumType{(:append, :replace)} = :replace

    selected :: Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()
end
