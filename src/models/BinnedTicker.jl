#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iBinnedTicker, Bokeh.Models.CustomJS, Bokeh.Models.ScanningColorMapper

@model mutable struct BinnedTicker <: iBinnedTicker

    syncable :: Bool = true

    num_major_ticks :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = 8

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    mapper :: iScanningColorMapper

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
