#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CompositeTicker <: iCompositeTicker

    desired_num_ticks :: Int64 = 6

    num_minor_ticks :: Int64 = 5

    tickers :: Vector{iTicker}
end
