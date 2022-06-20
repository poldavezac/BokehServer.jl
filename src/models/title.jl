#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct Title <: iTitle

    align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    border_line_dash :: Bokeh.Model.DashPattern

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    border_line_width :: Float64 = 1.0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    name :: Bokeh.Model.Nullable{String} = nothing

    offset :: Float64 = 0.0

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    standoff :: Float64 = 10.0

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text :: String = ""

    text_alpha :: Bokeh.Model.Percent = 1.0

    text_color :: Bokeh.Model.Color = "rgb(68,68,68)"

    text_font :: String = "helvetica"

    text_font_size :: String = "13px"

    text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :bold

    text_line_height :: Float64 = 1.0

    vertical_align :: Bokeh.Model.EnumType{(:middle, :bottom, :top)} = :bottom

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
