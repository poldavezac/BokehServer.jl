#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@wrap mutable struct AjaxDataSource <: iAjaxDataSource

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    content_type :: String = "application/json"

    data :: Bokeh.Model.DataDict

    data_url :: String

    http_headers :: Dict{String, String}

    if_modified :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    method :: Bokeh.Model.EnumType{(:POST, :GET)} = :POST

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    polling_interval :: Bokeh.Model.Nullable{Int64} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
