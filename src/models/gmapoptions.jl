#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GMapOptions <: iGMapOptions

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    lat :: Float64

    lng :: Float64

    map_type :: Bokeh.Model.EnumType{(:hybrid, :roadmap, :satellite, :terrain)} = :roadmap

    name :: Bokeh.Model.Nullable{String} = nothing

    scale_control :: Bool = false

    styles :: Bokeh.Model.JSONString

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    tilt :: Int64 = 45

    zoom :: Int64 = 12
end
