#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iFactorRange, Bokeh.Models.CustomJS

@model mutable struct FactorRange <: iFactorRange

    syncable :: Bool = true

    group_padding :: Float64 = 1.4

    subgroup_padding :: Float64 = 0.8

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    start :: Bokeh.Model.ReadOnly{Float64} = 0.0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    range_padding :: Float64 = 0.0

    subscribed_events :: Vector{Symbol}

    finish :: Bokeh.Model.ReadOnly{Float64} = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Bokeh.Model.Nullable{Float64} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    factor_padding :: Float64 = 0.0

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}} = String[]

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
