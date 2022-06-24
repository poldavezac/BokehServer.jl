#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct CategoricalAxis <: iCategoricalAxis

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

    formatter :: iTickFormatter = CategoricalTickFormatter()

    group :: Model.Nullable{iRendererGroup} = nothing

    group_label_orientation :: Union{Float64, Model.EnumType{(:horizontal, :vertical, :parallel, :normal)}} = :parallel

    group_text_align :: Model.TextAlign = :left

    group_text_alpha :: Model.Percent = 1.0

    group_text_baseline :: Model.TextBaseline = :bottom

    group_text_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    group_text_font :: String = "helvetica"

    group_text_font_size :: Model.FontSize = "11px"

    group_text_font_style :: Model.FontStyle = :bold

    group_text_line_height :: Float64 = 1.2

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

    separator_line_alpha :: Model.Percent = 1.0

    separator_line_cap :: Model.LineCap = :butt

    separator_line_color :: Model.Nullable{Model.Color} = "rgb(211,211,211)"

    separator_line_dash :: Model.DashPattern = Int64[]

    separator_line_dash_offset :: Int64 = 0

    separator_line_join :: Model.LineJoin = :bevel

    separator_line_width :: Float64 = 2.0

    subgroup_label_orientation :: Union{Float64, Model.EnumType{(:horizontal, :vertical, :parallel, :normal)}} = :parallel

    subgroup_text_align :: Model.TextAlign = :left

    subgroup_text_alpha :: Model.Percent = 1.0

    subgroup_text_baseline :: Model.TextBaseline = :bottom

    subgroup_text_color :: Model.Nullable{Model.Color} = "rgb(68,68,68)"

    subgroup_text_font :: String = "helvetica"

    subgroup_text_font_size :: Model.FontSize = "11px"

    subgroup_text_font_style :: Model.FontStyle = :bold

    subgroup_text_line_height :: Float64 = 1.2

    ticker :: iTicker = CategoricalTicker()

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
