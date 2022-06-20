#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CategoricalMarkerMapper <: iCategoricalMarkerMapper

    default_value :: Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = :circle

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Model.Nullable{Int64} = nothing

    markers :: Vector{Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)}}

    start :: Int64 = 0
end
