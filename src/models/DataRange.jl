#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iDataRange, Bokeh.Models.CustomJS

@model mutable struct DataRange <: iDataRange

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    names :: Vector{String} = String[]

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{<:iModel}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
