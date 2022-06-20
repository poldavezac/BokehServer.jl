#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct CategoricalPatternMapper <: iCategoricalPatternMapper

    default_value :: Bokeh.Model.EnumType{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = :blank

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    patterns :: Vector{Bokeh.Model.EnumType{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)}}

    start :: Int64 = 0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
