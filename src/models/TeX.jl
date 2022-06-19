#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iTeX, Bokeh.Models.CustomJS

@model mutable struct TeX <: iTeX

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    text :: String

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    inline :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    macros :: Dict{String, Union{String, Tuple{String, Int64}}}
end
