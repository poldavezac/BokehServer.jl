#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Image <: iImage

    color_mapper :: iColorMapper = LinearColorMapper()

    dh :: Bokeh.Model.DistanceSpec = (field = "dh",)

    dh_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    dilate :: Bool = false

    dw :: Bokeh.Model.DistanceSpec = (field = "dw",)

    dw_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    image :: Bokeh.Model.Spec{Float64} = (field = "image",)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)
end
