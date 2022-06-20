#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct CategoricalMapper <: iCategoricalMapper

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    start :: Int64 = 0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
