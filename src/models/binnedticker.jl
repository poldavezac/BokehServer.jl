#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BinnedTicker <: iBinnedTicker

    syncable :: Bool = true

    num_major_ticks :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = 8

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mapper :: iScanningColorMapper

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
