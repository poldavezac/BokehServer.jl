#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatetimeTickFormatter <: iDatetimeTickFormatter

    days :: Vector{String} = ["%m/%d", "%a%d"]

    hourmin :: Vector{String} = ["%H:%M"]

    hours :: Vector{String} = ["%Hh", "%H:%M"]

    microseconds :: Vector{String} = ["%fus"]

    milliseconds :: Vector{String} = ["%3Nms", "%S.%3Ns"]

    minsec :: Vector{String} = [":%M:%S"]

    minutes :: Vector{String} = [":%M", "%Mm"]

    months :: Vector{String} = ["%m/%Y", "%b %Y"]

    seconds :: Vector{String} = ["%Ss"]

    years :: Vector{String} = ["%Y"]
end
