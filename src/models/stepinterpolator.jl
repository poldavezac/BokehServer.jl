#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct StepInterpolator <: iStepInterpolator

    clip :: Bool = true

    data :: Bokeh.Model.Nullable{iColumnarDataSource} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :after

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x :: Union{String, Vector{Float64}}

    y :: Union{String, Vector{Float64}}
end
