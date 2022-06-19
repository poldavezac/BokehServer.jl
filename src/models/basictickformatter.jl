#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BasicTickFormatter <: iBasicTickFormatter

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    precision :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    power_limit_low :: Int64 = -3

    subscribed_events :: Vector{Symbol}

    use_scientific :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    power_limit_high :: Int64 = 5

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
