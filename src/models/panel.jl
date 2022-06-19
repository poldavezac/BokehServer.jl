#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Panel <: iPanel

    syncable :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    title :: String = ""

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    closable :: Bool = false

    child :: iLayoutDOM

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
