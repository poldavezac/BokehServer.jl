#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Interpolator <: iInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    clip :: Bool = true

    subscribed_events :: Vector{Symbol}

    data :: Bokeh.Model.Nullable{iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
