#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iLogTickFormatter, Bokeh.Models.CustomJS

@model mutable struct LogTickFormatter <: iLogTickFormatter

    min_exponent :: Int64 = 0

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    ticker :: Bokeh.Model.Nullable{<:iTicker} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
