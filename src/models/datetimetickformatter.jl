#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct DatetimeTickFormatter <: iDatetimeTickFormatter

    days :: Vector{String} = ["%m/%d", "%a%d"]

    hourmin :: Vector{String} = ["%H:%M"]

    hours :: Vector{String} = ["%Hh", "%H:%M"]

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    microseconds :: Vector{String} = ["%fus"]

    milliseconds :: Vector{String} = ["%3Nms", "%S.%3Ns"]

    minsec :: Vector{String} = [":%M:%S"]

    minutes :: Vector{String} = [":%M", "%Mm"]

    months :: Vector{String} = ["%m/%Y", "%b %Y"]

    name :: Bokeh.Model.Nullable{String} = nothing

    seconds :: Vector{String} = ["%Ss"]

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    years :: Vector{String} = ["%Y"]
end
