#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iRange1d, Bokeh.Models.CustomJS

@model mutable struct Range1d <: iRange1d

    syncable :: Bool = true

    reset_end :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    start :: Union{Float64, Dates.DateTime, Dates.Period} = 0.0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    finish :: Union{Float64, Dates.DateTime, Dates.Period} = 1.0

    name :: Bokeh.Model.Nullable{String} = nothing

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    reset_start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
