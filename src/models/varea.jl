#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct VArea <: iVArea

    fill_alpha :: Bokeh.Model.Percent = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_extra :: Dict{String, iTexture}

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    y1 :: Bokeh.Model.Spec{Float64} = (field = "y1",)

    y2 :: Bokeh.Model.Spec{Float64} = (field = "y2",)
end
