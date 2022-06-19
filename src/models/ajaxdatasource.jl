#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct AjaxDataSource <: iAjaxDataSource

    syncable :: Bool = true

    if_modified :: Bool = false

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    method :: Bokeh.Model.EnumType{(:POST, :GET)} = :POST

    content_type :: String = "application/json"

    polling_interval :: Bokeh.Model.Nullable{Int64} = nothing

    http_headers :: Dict{String, String}

    subscribed_events :: Vector{Symbol}

    data :: Bokeh.Model.DataDict

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()

    data_url :: String

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
