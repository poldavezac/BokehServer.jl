#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct ColorBar <: iColorBar

    background_fill_alpha :: Model.Percent = 0.95

    background_fill_color :: Model.Nullable{Model.Color} = "#FFFFFF"

    bar_line_alpha :: Model.Percent = 1.0

    bar_line_cap :: Model.LineCap = :butt

    bar_line_color :: Model.Nullable{Model.Color} = nothing

    bar_line_dash :: Model.DashPattern = Int64[]

    bar_line_dash_offset :: Int64 = 0

    bar_line_join :: Model.LineJoin = :bevel

    bar_line_width :: Float64 = 1.0

    border_line_alpha :: Model.Percent = 1.0

    border_line_cap :: Model.LineCap = :butt

    border_line_color :: Model.Nullable{Model.Color} = nothing

    border_line_dash :: Model.DashPattern = Int64[]

    border_line_dash_offset :: Int64 = 0

    border_line_join :: Model.LineJoin = :bevel

    border_line_width :: Float64 = 1.0

    color_mapper :: iColorMapper

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    formatter :: Union{iTickFormatter, Model.EnumType{(:auto,)}} = :auto

    group :: Model.Nullable{iRendererGroup} = nothing

    height :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    label_standoff :: Int64 = 5

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    location :: Union{Tuple{Float64, Float64}, Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}} = Dict{Union{Float64, String}, Union{iBaseText, String}}()

    major_label_policy :: iLabelingPolicy = NoOverlap()

    major_label_text_align :: Model.TextAlign = :left

    major_label_text_alpha :: Model.Percent = 1.0

    major_label_text_baseline :: Model.TextBaseline = :bottom

    major_label_text_color :: Model.Nullable{Model.Color} = "#444444"

    major_label_text_font :: String = "helvetica"

    major_label_text_font_size :: Model.FontSize = "11px"

    major_label_text_font_style :: Model.FontStyle = :normal

    major_label_text_line_height :: Float64 = 1.2

    major_tick_in :: Int64 = 5

    major_tick_line_alpha :: Model.Percent = 1.0

    major_tick_line_cap :: Model.LineCap = :butt

    major_tick_line_color :: Model.Nullable{Model.Color} = "#FFFFFF"

    major_tick_line_dash :: Model.DashPattern = Int64[]

    major_tick_line_dash_offset :: Int64 = 0

    major_tick_line_join :: Model.LineJoin = :bevel

    major_tick_line_width :: Float64 = 1.0

    major_tick_out :: Int64 = 0

    margin :: Int64 = 30

    minor_tick_in :: Int64 = 0

    minor_tick_line_alpha :: Model.Percent = 1.0

    minor_tick_line_cap :: Model.LineCap = :butt

    minor_tick_line_color :: Model.Nullable{Model.Color} = nothing

    minor_tick_line_dash :: Model.DashPattern = Int64[]

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_line_join :: Model.LineJoin = :bevel

    minor_tick_line_width :: Float64 = 1.0

    minor_tick_out :: Int64 = 0

    orientation :: Model.EnumType{(:horizontal, :vertical, :auto)} = :auto

    padding :: Int64 = 10

    scale_alpha :: Float64 = 1.0

    ticker :: Union{iTicker, Model.EnumType{(:auto,)}} = :auto

    title :: Model.Nullable{String} = nothing

    title_standoff :: Int64 = 2

    title_text_align :: Model.TextAlign = :left

    title_text_alpha :: Model.Percent = 1.0

    title_text_baseline :: Model.TextBaseline = :bottom

    title_text_color :: Model.Nullable{Model.Color} = "#444444"

    title_text_font :: String = "helvetica"

    title_text_font_size :: Model.FontSize = "13px"

    title_text_font_style :: Model.FontStyle = :italic

    title_text_line_height :: Float64 = 1.2

    visible :: Bool = true

    width :: Union{Int64, Model.EnumType{(:auto,)}} = :auto

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
