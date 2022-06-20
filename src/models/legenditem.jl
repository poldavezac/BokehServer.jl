#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct LegendItem <: iLegendItem

    index :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    label :: Bokeh.Model.Nullable{Bokeh.Model.Spec{String}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true
end
