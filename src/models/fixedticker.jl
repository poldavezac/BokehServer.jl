#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct FixedTicker <: iFixedTicker

    desired_num_ticks :: Int64 = 6

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    minor_ticks :: Vector{Float64} = Float64[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    ticks :: Vector{Float64} = Float64[]
end
