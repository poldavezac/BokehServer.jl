#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iCategoricalMarkerMapper, Bokeh.Models.CustomJS

@model mutable struct CategoricalMarkerMapper <: iCategoricalMarkerMapper

    syncable :: Bool = true

    start :: Int64 = 0

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    markers :: Vector{Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    default_value :: Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = :circle

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}
end
