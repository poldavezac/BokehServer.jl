#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LogTickFormatter <: iLogTickFormatter

    syncable :: Bool = true

    min_exponent :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    ticker :: Bokeh.Model.Nullable{iTicker} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
