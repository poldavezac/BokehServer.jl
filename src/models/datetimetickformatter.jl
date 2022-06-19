#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatetimeTickFormatter <: iDatetimeTickFormatter

    months :: Vector{String} = ["%m/%Y", "%b %Y"]

    syncable :: Bool = true

    minutes :: Vector{String} = [":%M", "%Mm"]

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    minsec :: Vector{String} = [":%M:%S"]

    years :: Vector{String} = ["%Y"]

    hours :: Vector{String} = ["%Hh", "%H:%M"]

    subscribed_events :: Vector{Symbol}

    hourmin :: Vector{String} = ["%H:%M"]

    microseconds :: Vector{String} = ["%fus"]

    name :: Bokeh.Model.Nullable{String} = nothing

    milliseconds :: Vector{String} = ["%3Nms", "%S.%3Ns"]

    seconds :: Vector{String} = ["%Ss"]

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    days :: Vector{String} = ["%m/%d", "%a%d"]
end
