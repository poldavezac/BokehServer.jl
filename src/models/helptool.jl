#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct HelpTool <: iHelpTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    redirect :: String = "https://docs.bokeh.org/en/latest/docs/user_guide/tools.html"
end
