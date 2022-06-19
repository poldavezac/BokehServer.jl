#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct VBar <: iVBar

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    top :: Bokeh.Model.Spec{Float64} = (field = "top",)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{Symbol}

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    bottom :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)
end
