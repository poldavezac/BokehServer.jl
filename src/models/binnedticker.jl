#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BinnedTicker <: iBinnedTicker

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mapper :: iScanningColorMapper

    name :: Bokeh.Model.Nullable{String} = nothing

    num_major_ticks :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = 8

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
