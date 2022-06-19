#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iBooleanFormatter, Bokeh.Models.CustomJS

@model mutable struct BooleanFormatter <: iBooleanFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.EnumType{(Symbol("check-square-o"), Symbol("check-circle"), :check, Symbol("check-circle-o"), Symbol("check-square"))} = :check

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
