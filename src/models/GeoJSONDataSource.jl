#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iGeoJSONDataSource, Bokeh.Models.SelectionPolicy, Bokeh.Models.CustomJS

@model mutable struct GeoJSONDataSource <: iGeoJSONDataSource

    syncable :: Bool = true

    geojson :: Bokeh.Model.JSONString

    selected :: Bokeh.Model.ReadOnly{<:iSelection} = Selection()

    name :: Bokeh.Model.Nullable{String} = nothing

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
