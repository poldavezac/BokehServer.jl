#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

using ..ModelTypes: iLegend, Bokeh.Models.CustomJS, Bokeh.Models.LegendItem

@model mutable struct Legend <: iLegend

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{<:iRendererGroup} = nothing

    label_height :: Int64 = 20

    label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    label_width :: Int64 = 20

    label_text_alpha :: Bokeh.Model.Percent = 1.0

    title_text_font :: String = "helvetica"

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    name :: Bokeh.Model.Nullable{String} = nothing

    inactive_fill_alpha :: Bokeh.Model.Percent = 1.0

    y_range_name :: String = "default"

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    margin :: Int64 = 10

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{<:iCustomJS}}

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    label_text_font_size :: Bokeh.Model.FontSize = "16px"

    label_text_line_height :: Float64 = 1.2

    label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    title :: Bokeh.Model.Nullable{String} = nothing

    glyph_width :: Int64 = 20

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    border_line_width :: Float64 = 1.0

    click_policy :: Bokeh.Model.EnumType{(:none, :hide, :mute)} = :none

    title_text_line_height :: Float64 = 1.2

    tags :: Vector{Any}

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    label_standoff :: Int64 = 5

    padding :: Int64 = 10

    label_text_font :: String = "helvetica"

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    border_line_dash :: Bokeh.Model.DashPattern

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    spacing :: Int64 = 3

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :vertical

    border_line_dash_offset :: Int64 = 0

    label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    x_range_name :: String = "default"

    items :: Vector{<:iLegendItem}

    coordinates :: Bokeh.Model.Nullable{<:iCoordinateMapping} = nothing

    inactive_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    glyph_height :: Int64 = 20

    title_standoff :: Int64 = 5
end
