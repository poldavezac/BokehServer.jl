#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Plot <: iPlot

    above :: Vector{iRenderer}

    align :: Union{Tuple{Model.EnumType{(:start, :end, :center)}, Model.EnumType{(:start, :end, :center)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    aspect_scale :: Float64 = 1.0

    background :: Model.Nullable{Model.Color} = nothing

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    below :: Vector{iRenderer}

    border_fill_alpha :: Model.Percent = 1.0

    border_fill_color :: Model.Nullable{Model.Color} = "rgb(128,128,128)"

    center :: Vector{iRenderer}

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    extra_x_ranges :: Dict{String, iRange}

    extra_x_scales :: Dict{String, iScale}

    extra_y_ranges :: Dict{String, iRange}

    extra_y_scales :: Dict{String, iScale}

    frame_height :: Model.Nullable{Int64} = nothing

    frame_width :: Model.Nullable{Int64} = nothing

    height :: Model.Nullable{Model.NonNegativeInt} = nothing

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    hidpi :: Bool = true

    inner_height :: Model.ReadOnly{Int64} = 0

    inner_width :: Model.ReadOnly{Int64} = 0

    left :: Vector{iRenderer}

    lod_factor :: Int64 = 10

    lod_interval :: Int64 = 300

    lod_threshold :: Model.Nullable{Int64} = 2000

    lod_timeout :: Int64 = 500

    margin :: Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    match_aspect :: Bool = false

    max_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    max_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_border :: Model.Nullable{Int64} = 5

    min_border_bottom :: Model.Nullable{Int64} = nothing

    min_border_left :: Model.Nullable{Int64} = nothing

    min_border_right :: Model.Nullable{Int64} = nothing

    min_border_top :: Model.Nullable{Int64} = nothing

    min_height :: Model.Nullable{Model.NonNegativeInt} = nothing

    min_width :: Model.Nullable{Model.NonNegativeInt} = nothing

    outer_height :: Model.ReadOnly{Int64} = 0

    outer_width :: Model.ReadOnly{Int64} = 0

    outline_line_alpha :: Model.Percent = 1.0

    outline_line_cap :: Model.EnumType{(:round, :square, :butt)} = :butt

    outline_line_color :: Model.Nullable{Model.Color} = "rgb(0,0,0)"

    outline_line_dash :: Model.DashPattern

    outline_line_dash_offset :: Int64 = 0

    outline_line_join :: Model.EnumType{(:round, :miter, :bevel)} = :bevel

    outline_line_width :: Float64 = 1.0

    output_backend :: Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    plot_height :: Model.Alias{:height}

    plot_width :: Model.Alias{:width}

    renderers :: Vector{iRenderer}

    reset_policy :: Model.EnumType{(:standard, :event_only)} = :standard

    right :: Vector{iRenderer}

    sizing_mode :: Model.Nullable{Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    title :: Union{Nothing, iTitle} = Title()

    title_location :: Model.Nullable{Model.EnumType{(:below, :left, :right, :above)}} = :above

    toolbar :: iToolbar = Toolbar()

    toolbar_location :: Model.Nullable{Model.EnumType{(:below, :left, :right, :above)}} = :right

    toolbar_sticky :: Bool = true

    visible :: Bool = true

    width :: Model.Nullable{Model.NonNegativeInt} = nothing

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    x_range :: iRange = DataRange1d()

    x_scale :: iScale = LinearScale()

    y_range :: iRange = DataRange1d()

    y_scale :: iScale = LinearScale()
end
