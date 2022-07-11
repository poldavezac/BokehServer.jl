#- file generated by BokehJL's 'CodeCreator': edit at your own risk! -#

@model mutable struct Plot <: iPlot

    above :: Vector{iRenderer} = iRenderer[]

    align :: Union{Tuple{Model.EnumType{(:start, :center, :end)}, Model.EnumType{(:start, :center, :end)}}, Model.EnumType{(:start, :center, :end)}} = :start

    aspect_ratio :: Union{Nothing, Float64, Model.EnumType{(:auto,)}} = nothing

    aspect_scale :: Float64 = 1.0

    background :: Union{Nothing, Model.Color} = nothing

    background_fill_alpha :: Model.Percent = 1.0

    background_fill_color :: Union{Nothing, Model.Color} = "#FFFFFF"

    below :: Vector{iRenderer} = iRenderer[]

    border_fill_alpha :: Model.Percent = 1.0

    border_fill_color :: Union{Nothing, Model.Color} = "#FFFFFF"

    center :: Vector{iRenderer} = iRenderer[]

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    extra_x_ranges :: Dict{String, iRange} = Dict{String, iRange}()

    extra_x_scales :: Dict{String, iScale} = Dict{String, iScale}()

    extra_y_ranges :: Dict{String, iRange} = Dict{String, iRange}()

    extra_y_scales :: Dict{String, iScale} = Dict{String, iScale}()

    frame_height :: Union{Nothing, Int64} = nothing

    frame_width :: Union{Nothing, Int64} = nothing

    height :: Union{Nothing, Model.NonNegativeInt} = 600

    height_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    hidpi :: Bool = true

    inner_height :: Model.ReadOnly{Int64} = 0

    inner_width :: Model.ReadOnly{Int64} = 0

    left :: Vector{iRenderer} = iRenderer[]

    lod_factor :: Int64 = 10

    lod_interval :: Int64 = 300

    lod_threshold :: Union{Nothing, Int64} = 2000

    lod_timeout :: Int64 = 500

    margin :: Union{Nothing, NTuple{4, Int64}} = (0, 0, 0, 0)

    match_aspect :: Bool = false

    max_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    max_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_border :: Union{Nothing, Int64} = 5

    min_border_bottom :: Union{Nothing, Int64} = nothing

    min_border_left :: Union{Nothing, Int64} = nothing

    min_border_right :: Union{Nothing, Int64} = nothing

    min_border_top :: Union{Nothing, Int64} = nothing

    min_height :: Union{Nothing, Model.NonNegativeInt} = nothing

    min_width :: Union{Nothing, Model.NonNegativeInt} = nothing

    outer_height :: Model.ReadOnly{Int64} = 0

    outer_width :: Model.ReadOnly{Int64} = 0

    outline_line_alpha :: Model.Percent = 1.0

    outline_line_cap :: Model.LineCap = :butt

    outline_line_color :: Union{Nothing, Model.Color} = "#E5E5E5"

    outline_line_dash :: Model.DashPattern = Int64[]

    outline_line_dash_offset :: Int64 = 0

    outline_line_join :: Model.LineJoin = :bevel

    outline_line_width :: Float64 = 1.0

    output_backend :: Model.EnumType{(:canvas, :svg, :webgl)} = :canvas

    plot_height :: Model.Alias{:height}

    plot_width :: Model.Alias{:width}

    renderers :: Vector{iRenderer} = iRenderer[]

    reset_policy :: Model.EnumType{(:standard, :event_only)} = :standard

    right :: Vector{iRenderer} = iRenderer[]

    sizing_mode :: Union{Nothing, Model.EnumType{(:stretch_width, :stretch_height, :stretch_both, :scale_width, :scale_height, :scale_both, :fixed)}} = nothing

    title :: Union{Nothing, iTitle} = Title()

    title_location :: Union{Nothing, Model.EnumType{(:above, :below, :left, :right)}} = :above

    toolbar :: iToolbar = Toolbar()

    toolbar_location :: Union{Nothing, Model.EnumType{(:above, :below, :left, :right)}} = :right

    toolbar_sticky :: Bool = true

    visible :: Bool = true

    width :: Union{Nothing, Model.NonNegativeInt} = 600

    width_policy :: Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    x_range :: iRange = DataRange1d()

    x_scale :: iScale = LinearScale()

    y_range :: iRange = DataRange1d()

    y_scale :: iScale = LinearScale()
end
