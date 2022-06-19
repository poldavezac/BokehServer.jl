#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Legend <: iLegend

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Bokeh.Model.DashPattern

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    click_policy :: Bokeh.Model.EnumType{(:none, :hide, :mute)} = :none

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    glyph_height :: Int64 = 20

    glyph_width :: Int64 = 20

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    inactive_fill_alpha :: Bokeh.Model.Percent = 1.0

    inactive_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    items :: Vector{iLegendItem}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    label_height :: Int64 = 20

    label_standoff :: Int64 = 5

    label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    label_text_alpha :: Bokeh.Model.Percent = 1.0

    label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    label_text_font :: String = "helvetica"

    label_text_font_size :: Bokeh.Model.FontSize = "16px"

    label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    label_text_line_height :: Float64 = 1.2

    label_width :: Int64 = 20

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    margin :: Int64 = 10

    name :: Bokeh.Model.Nullable{String} = nothing

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :vertical

    padding :: Int64 = 10

    spacing :: Int64 = 3

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: Bokeh.Model.Nullable{String} = nothing

    title_standoff :: Int64 = 5

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    title_text_font :: String = "helvetica"

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    title_text_line_height :: Float64 = 1.2

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
