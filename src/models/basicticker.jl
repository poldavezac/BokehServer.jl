#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct BasicTicker <: iBasicTicker

    base :: Float64 = 10.0

    desired_num_ticks :: Int64 = 6

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    max_interval :: Union{Nothing, Float64} = nothing

    min_interval :: Float64 = 0.0

    num_minor_ticks :: Int64 = 5
end
export BasicTicker
