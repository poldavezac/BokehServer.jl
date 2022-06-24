#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DatetimeAxis <: iDatetimeAxis

    axis_label :: Model.Nullable{Union{iBaseText, String}} = nothing

    axis_label_standoff :: Int64 = 5

    axis_label_text_align :: Model.TextAlign = :left

    axis_label_text_alpha :: Model.Percent = 1.0

    axis_label_text_baseline :: Model.TextBaseline = :bottom

    axis_label_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    axis_label_text_font :: String = "helvetica"

    axis_label_text_font_size :: Model.FontSize = "16px"

    axis_label_text_font_style :: Model.FontStyle = :normal

    axis_label_text_line_height :: Float64 = 1.2

    axis_line_alpha :: Model.Percent = 1.0

    axis_line_cap :: Model.LineCap = :butt

    axis_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    axis_line_dash :: Model.DashPattern = Int64[]

    axis_line_dash_offset :: Int64 = 0

    axis_line_join :: Model.LineJoin = :bevel

    axis_line_width :: Float64 = 1.0

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Model.EnumType{(:auto,)}} = :auto

    coordinates :: Model.Nullable{iCoordinateMapping} = nothing

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    formatter :: iTickFormatter = DatetimeTickFormatter()

    group :: Model.Nullable{iRendererGroup} = nothing

    level :: Model.EnumType{(:image, :underlay, :glyph, :guide, :annotation, :overlay)} = :image

    major_label_orientation :: Union{Float64, Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}} = Dict{Union{Float64, String}, Union{iBaseText, String}}()

    major_label_policy :: iLabelingPolicy = AllLabels()

    major_label_standoff :: Int64 = 5

    major_label_text_align :: Model.TextAlign = :left

    major_label_text_alpha :: Model.Percent = 1.0

    major_label_text_baseline :: Model.TextBaseline = :bottom

    major_label_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    major_label_text_font :: String = "helvetica"

    major_label_text_font_size :: Model.FontSize = "16px"

    major_label_text_font_style :: Model.FontStyle = :normal

    major_label_text_line_height :: Float64 = 1.2

    major_tick_in :: Int64 = 2

    major_tick_line_alpha :: Model.Percent = 1.0

    major_tick_line_cap :: Model.LineCap = :butt

    major_tick_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    major_tick_line_dash :: Model.DashPattern = Int64[]

    major_tick_line_dash_offset :: Int64 = 0

    major_tick_line_join :: Model.LineJoin = :bevel

    major_tick_line_width :: Float64 = 1.0

    major_tick_out :: Int64 = 6

    minor_tick_in :: Int64 = 0

    minor_tick_line_alpha :: Model.Percent = 1.0

    minor_tick_line_cap :: Model.LineCap = :butt

    minor_tick_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    minor_tick_line_dash :: Model.DashPattern = Int64[]

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_line_join :: Model.LineJoin = :bevel

    minor_tick_line_width :: Float64 = 1.0

    minor_tick_out :: Int64 = 4

    ticker :: iTicker = DatetimeTicker()

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
