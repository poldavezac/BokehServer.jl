#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Selection <: iSelection

    syncable :: Bool = true

    indices :: Vector{Int64} = Int64[]

    multiline_indices :: Dict{String, Vector{Int64}}

    line_indices :: Vector{Int64} = Int64[]

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
