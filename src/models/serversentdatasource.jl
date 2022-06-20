#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct ServerSentDataSource <: iServerSentDataSource

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    data :: Bokeh.Model.DataDict

    data_url :: String

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
