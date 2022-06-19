#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TapTool <: iTapTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    behavior :: Bokeh.Model.EnumType{(:select, :inspect)} = :select

    subscribed_events :: Vector{Symbol}

    gesture :: Bokeh.Model.EnumType{(:tap, :doubletap)} = :tap

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
