#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DataRange <: iDataRange

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iModel}}

    names :: Vector{String} = String[]

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
