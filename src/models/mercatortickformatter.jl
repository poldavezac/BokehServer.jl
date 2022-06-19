#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct MercatorTickFormatter <: iMercatorTickFormatter

    dimension :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:lat, :lon)}} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    power_limit_high :: Int64 = 5

    power_limit_low :: Int64 = -3

    precision :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    use_scientific :: Bool = true
end
