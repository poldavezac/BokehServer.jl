#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AjaxDataSource <: iAjaxDataSource

    adapter :: Model.Nullable{iCustomJS} = nothing

    content_type :: String = "application/json"

    data :: Model.DataDict

    data_url :: String

    http_headers :: Dict{String, String}

    if_modified :: Bool = false

    max_size :: Model.Nullable{Int64} = nothing

    method :: Model.EnumType{(:POST, :GET)} = :POST

    mode :: Model.EnumType{(:append, :replace)} = :replace

    polling_interval :: Model.Nullable{Int64} = nothing

    selected :: Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()
end
