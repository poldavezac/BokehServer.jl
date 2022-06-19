#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ImageURL <: iImageURL

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :top_left

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    dilate :: Bool = false

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    h :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    h_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    retry_attempts :: Int64 = 0

    retry_timeout :: Int64 = 0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    url :: Bokeh.Model.Spec{String} = (field = "url",)

    w :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    w_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)
end
