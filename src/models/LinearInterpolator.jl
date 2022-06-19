#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iLinearInterpolator, Bokeh.Models.CustomJS

@model mutable struct LinearInterpolator <: iLinearInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    clip :: Bool = true

    data :: Bokeh.Model.Nullable{<:iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
