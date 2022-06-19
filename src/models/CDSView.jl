#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCDSView, Bokeh.Models.Filter, Bokeh.Models.ColumnarDataSource, Bokeh.Models.CustomJS

@model mutable struct CDSView <: iCDSView

    syncable :: Bool = true

    filters :: Vector{<:iFilter}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    source :: iColumnarDataSource

    tags :: Vector{Any}
end
