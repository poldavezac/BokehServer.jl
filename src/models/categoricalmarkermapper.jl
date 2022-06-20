#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct CategoricalMarkerMapper <: iCategoricalMarkerMapper

    default_value :: Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = :circle

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    markers :: Vector{Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)}}

    name :: Bokeh.Model.Nullable{String} = nothing

    start :: Int64 = 0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
