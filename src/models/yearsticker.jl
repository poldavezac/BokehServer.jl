#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct YearsTicker <: iYearsTicker

    desired_num_ticks :: Int64 = 6

    interval :: Float64

    num_minor_ticks :: Int64 = 5
end
