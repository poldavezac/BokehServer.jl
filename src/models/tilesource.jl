#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TileSource <: iTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{Symbol}

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
