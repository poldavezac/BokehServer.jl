#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Jitter <: iJitter

    distribution :: Bokeh.Model.EnumType{(:normal, :uniform)} = :uniform

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mean :: Float64 = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    range :: Bokeh.Model.Nullable{iRange} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    width :: Float64 = 1.0
end
