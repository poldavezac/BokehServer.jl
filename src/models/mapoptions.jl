#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct MapOptions <: iMapOptions

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    lat :: Float64

    lng :: Float64

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    zoom :: Int64 = 12
end
