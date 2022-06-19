#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GMapOptions <: iGMapOptions

    syncable :: Bool = true

    scale_control :: Bool = false

    lng :: Float64

    zoom :: Int64 = 12

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    tilt :: Int64 = 45

    subscribed_events :: Vector{Symbol}

    styles :: Bokeh.Model.JSONString

    name :: Bokeh.Model.Nullable{String} = nothing

    lat :: Float64

    map_type :: Bokeh.Model.EnumType{(:hybrid, :roadmap, :satellite, :terrain)} = :roadmap

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
