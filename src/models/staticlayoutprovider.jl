#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct StaticLayoutProvider <: iStaticLayoutProvider

    graph_layout :: Dict{Union{Int64, String}, Vector{Any}}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
