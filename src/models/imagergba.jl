#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageRGBA <: iImageRGBA

    syncable :: Bool = true

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    dw :: Bokeh.Model.DistanceSpec = (field = "dw",)

    subscribed_events :: Vector{Symbol}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    dilate :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    dh_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    image :: Bokeh.Model.Spec{Float64} = (field = "image",)

    dw_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    dh :: Bokeh.Model.DistanceSpec = (field = "dh",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
