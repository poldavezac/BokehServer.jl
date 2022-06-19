#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iMercatorTickFormatter, Bokeh.Models.CustomJS

@model mutable struct MercatorTickFormatter <: iMercatorTickFormatter

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    power_limit_low :: Int64 = -3

    precision :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    subscribed_events :: Vector{Symbol}

    use_scientific :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    dimension :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:lat, :lon)}} = nothing

    power_limit_high :: Int64 = 5

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
