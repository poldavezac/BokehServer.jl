#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TileSource <: iTileSource

    attribution :: String = ""

    extra_url_vars :: Dict{String, Any}

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_zoom :: Int64 = 30

    min_zoom :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    tile_size :: Int64 = 256

    url :: String = ""

    x_origin_offset :: Float64

    y_origin_offset :: Float64
end
