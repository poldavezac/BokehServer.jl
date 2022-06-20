#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Range1d <: iRange1d

    bounds :: Model.Nullable{Model.MinMaxBounds} = nothing

    finish :: Union{Float64, Dates.DateTime, Dates.Period} = 1.0

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    reset_end :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    reset_start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    start :: Union{Float64, Dates.DateTime, Dates.Period} = 0.0
end
