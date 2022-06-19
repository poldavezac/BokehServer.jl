#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TeX <: iTeX

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    text :: String

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    macros :: Dict{String, Union{String, Tuple{String, Int64}}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    inline :: Bool = false
end
