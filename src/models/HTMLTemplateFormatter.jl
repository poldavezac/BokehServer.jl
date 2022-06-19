#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iHTMLTemplateFormatter, Bokeh.Models.CustomJS

@model mutable struct HTMLTemplateFormatter <: iHTMLTemplateFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    template :: String = "<%= value %>"

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}
end
