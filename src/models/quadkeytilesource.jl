#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct QUADKEYTileSource <: iQUADKEYTileSource

    attribution :: String = ""

    extra_url_vars :: Dict{String, Any} = Dict{String, Any}()

    initial_resolution :: Model.Nullable{Float64} = nothing

    max_zoom :: Int64 = 30

    min_zoom :: Int64 = 0

    snap_to_zoom :: Bool = false

    tile_size :: Int64 = 256

    url :: String = ""

    wrap_around :: Bool = true

    x_origin_offset :: Float64

    y_origin_offset :: Float64
end
glyphargs(::Type{QUADKEYTileSource}) = (:url, :tile_size, :min_zoom, :max_zoom, :x_origin_offset, :y_origin_offset, :extra_url_vars, :initial_resolution)
