#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct TapTool <: iTapTool

    behavior :: Bokeh.Model.EnumType{(:select, :inspect)} = :select

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    gesture :: Bokeh.Model.EnumType{(:tap, :doubletap)} = :tap

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
