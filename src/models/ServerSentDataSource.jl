#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iServerSentDataSource, Bokeh.Models.SelectionPolicy, Bokeh.Models.CustomJS

@model mutable struct ServerSentDataSource <: iServerSentDataSource

    syncable :: Bool = true

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    data :: Bokeh.Model.DataDict

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    adapter :: Bokeh.Model.Nullable{<:iCustomJS} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{<:iSelection} = Selection()

    data_url :: String

    selection_policy :: iSelectionPolicy = UnionRenderers()

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
