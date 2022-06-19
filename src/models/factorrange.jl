#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct FactorRange <: iFactorRange

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    factor_padding :: Float64 = 0.0

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}} = String[]

    finish :: Bokeh.Model.ReadOnly{Float64} = 0.0

    group_padding :: Float64 = 1.4

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Bokeh.Model.Nullable{Float64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    range_padding :: Float64 = 0.0

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    start :: Bokeh.Model.ReadOnly{Float64} = 0.0

    subgroup_padding :: Float64 = 0.8

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
