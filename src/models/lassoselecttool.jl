#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct LassoSelectTool <: iLassoSelectTool

    description :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    overlay :: iPolyAnnotation = PolyAnnotation()

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    select_every_mousemove :: Bool = true

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
