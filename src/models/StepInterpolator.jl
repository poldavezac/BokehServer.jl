#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iStepInterpolator, Bokeh.Models.CustomJS

@model mutable struct StepInterpolator <: iStepInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    clip :: Bool = true

    data :: Bokeh.Model.Nullable{<:iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :after

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
