#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct TileSource <: iTileSource

    attribution :: String = ""

    extra_url_vars :: Dict{String, Any} = Dict{String, Any}()

    initial_resolution :: Union{Nothing, Float64} = nothing

    max_zoom :: Int64 = 30

    min_zoom :: Int64 = 0

    tile_size :: Int64 = 256

    url :: String = ""

    x_origin_offset :: Float64 = required

    y_origin_offset :: Float64 = required
end
export TileSource
glyphargs(::Type{TileSource}) = (:url, :tile_size, :min_zoom, :max_zoom, :extra_url_vars)
