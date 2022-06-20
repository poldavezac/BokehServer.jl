#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct Range1d <: iRange1d

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    finish :: Union{Float64, Dates.DateTime, Dates.Period} = 1.0

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    reset_end :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    reset_start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    start :: Union{Float64, Dates.DateTime, Dates.Period} = 0.0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
