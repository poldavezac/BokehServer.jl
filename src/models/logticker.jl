#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LogTicker <: iLogTicker

    base :: Float64 = 10.0

    desired_num_ticks :: Int64 = 6

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    max_interval :: Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    num_minor_ticks :: Int64 = 5
end
