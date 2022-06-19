#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iImageURL, Bokeh.Models.CustomJS

@model mutable struct ImageURL <: iImageURL

    syncable :: Bool = true

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    retry_timeout :: Int64 = 0

    h :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    tags :: Vector{Any}

    w :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    subscribed_events :: Vector{Symbol}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    url :: Bokeh.Model.Spec{String} = (field = "url",)

    dilate :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    retry_attempts :: Int64 = 0

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    h_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :top_left

    w_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end
