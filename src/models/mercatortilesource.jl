#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct MercatorTileSource <: iMercatorTileSource

    attribution :: String = ""

    extra_url_vars :: Dict{String, Any} = Dict{String, Any}()

    initial_resolution :: Union{Nothing, Float64} = 156543.03392804097

    max_zoom :: Int64 = 30

    min_zoom :: Int64 = 0

    snap_to_zoom :: Bool = false

    tile_size :: Int64 = 256

    url :: String = ""

    wrap_around :: Bool = true

    x_origin_offset :: Float64 = 2.003750834e7

    y_origin_offset :: Float64 = 2.003750834e7
end
export MercatorTileSource
glyphargs(::Type{MercatorTileSource}) = (:url, :tile_size, :min_zoom, :max_zoom, :x_origin_offset, :y_origin_offset, :extra_url_vars, :initial_resolution)
