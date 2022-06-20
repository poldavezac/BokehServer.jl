#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GMapOptions <: iGMapOptions

    lat :: Float64

    lng :: Float64

    map_type :: Model.EnumType{(:hybrid, :roadmap, :satellite, :terrain)} = :roadmap

    scale_control :: Bool = false

    styles :: Model.JSONString

    tilt :: Int64 = 45

    zoom :: Int64 = 12
end
