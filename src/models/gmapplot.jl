#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GMapPlot <: iGMapPlot

    syncable :: Bool = true

    min_border :: Bokeh.Model.Nullable{Int64} = 5

    border_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    map_options :: iGMapOptions

    outline_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    above :: Vector{iRenderer}

    inner_width :: Bokeh.Model.ReadOnly{Int64} = 0

    x_range :: iRange = DataRange1d()

    outer_width :: Bokeh.Model.ReadOnly{Int64} = 0

    inner_height :: Bokeh.Model.ReadOnly{Int64} = 0

    lod_interval :: Int64 = 300

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    min_border_top :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    outline_line_alpha :: Bokeh.Model.Percent = 1.0

    border_fill_alpha :: Bokeh.Model.Percent = 1.0

    below :: Vector{iRenderer}

    frame_width :: Bokeh.Model.Nullable{Int64} = nothing

    extra_y_ranges :: Dict{String, iRange}

    min_border_left :: Bokeh.Model.Nullable{Int64} = nothing

    plot_height :: Bokeh.Model.Alias{:height}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    title_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :above

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    lod_factor :: Int64 = 10

    output_backend :: Bokeh.Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    extra_x_scales :: Dict{String, iScale}

    title :: Union{Nothing, iTitle} = Title()

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    right :: Vector{iRenderer}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    reset_policy :: Bokeh.Model.EnumType{(:standard, :event_only)} = :standard

    min_border_right :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    y_range :: iRange = DataRange1d()

    toolbar_sticky :: Bool = true

    outline_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    renderers :: Vector{iRenderer}

    outline_line_dash :: Bokeh.Model.DashPattern

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    api_key :: Bokeh.Model.Base64String

    left :: Vector{iRenderer}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    hidpi :: Bool = true

    outer_height :: Bokeh.Model.ReadOnly{Int64} = 0

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{Symbol}

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    outline_line_dash_offset :: Int64 = 0

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    outline_line_width :: Float64 = 1.0

    match_aspect :: Bool = false

    extra_y_scales :: Dict{String, iScale}

    lod_threshold :: Bokeh.Model.Nullable{Int64} = 2000

    outline_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    frame_height :: Bokeh.Model.Nullable{Int64} = nothing

    y_scale :: iScale = LinearScale()

    disabled :: Bool = false

    aspect_scale :: Float64 = 1.0

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    api_version :: String = "weekly"

    lod_timeout :: Int64 = 500

    toolbar :: iToolbar = Toolbar()

    center :: Vector{iRenderer}

    toolbar_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :right

    min_border_bottom :: Bokeh.Model.Nullable{Int64} = nothing

    extra_x_ranges :: Dict{String, iRange}

    x_scale :: iScale = LinearScale()

    plot_width :: Bokeh.Model.Alias{:width}
end
