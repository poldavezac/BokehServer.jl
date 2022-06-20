#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct GMapPlot <: iGMapPlot

    above :: Vector{iRenderer}

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    api_key :: Bokeh.Model.Base64String

    api_version :: String = "weekly"

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    aspect_scale :: Float64 = 1.0

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    below :: Vector{iRenderer}

    border_fill_alpha :: Bokeh.Model.Percent = 1.0

    border_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    center :: Vector{iRenderer}

    css_classes :: Vector{String} = String[]

    disabled :: Bool = false

    extra_x_ranges :: Dict{String, iRange}

    extra_x_scales :: Dict{String, iScale}

    extra_y_ranges :: Dict{String, iRange}

    extra_y_scales :: Dict{String, iScale}

    frame_height :: Bokeh.Model.Nullable{Int64} = nothing

    frame_width :: Bokeh.Model.Nullable{Int64} = nothing

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    hidpi :: Bool = true

    inner_height :: Bokeh.Model.ReadOnly{Int64} = 0

    inner_width :: Bokeh.Model.ReadOnly{Int64} = 0

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    left :: Vector{iRenderer}

    lod_factor :: Int64 = 10

    lod_interval :: Int64 = 300

    lod_threshold :: Bokeh.Model.Nullable{Int64} = 2000

    lod_timeout :: Int64 = 500

    map_options :: iGMapOptions

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    match_aspect :: Bool = false

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_border :: Bokeh.Model.Nullable{Int64} = 5

    min_border_bottom :: Bokeh.Model.Nullable{Int64} = nothing

    min_border_left :: Bokeh.Model.Nullable{Int64} = nothing

    min_border_right :: Bokeh.Model.Nullable{Int64} = nothing

    min_border_top :: Bokeh.Model.Nullable{Int64} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    outer_height :: Bokeh.Model.ReadOnly{Int64} = 0

    outer_width :: Bokeh.Model.ReadOnly{Int64} = 0

    outline_line_alpha :: Bokeh.Model.Percent = 1.0

    outline_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    outline_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    outline_line_dash :: Bokeh.Model.DashPattern

    outline_line_dash_offset :: Int64 = 0

    outline_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    outline_line_width :: Float64 = 1.0

    output_backend :: Bokeh.Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    plot_height :: Bokeh.Model.Alias{:height}

    plot_width :: Bokeh.Model.Alias{:width}

    renderers :: Vector{iRenderer}

    reset_policy :: Bokeh.Model.EnumType{(:standard, :event_only)} = :standard

    right :: Vector{iRenderer}

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    title :: Union{Nothing, iTitle} = Title()

    title_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :above

    toolbar :: iToolbar = Toolbar()

    toolbar_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :right

    toolbar_sticky :: Bool = true

    visible :: Bool = true

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    x_range :: iRange = DataRange1d()

    x_scale :: iScale = LinearScale()

    y_range :: iRange = DataRange1d()

    y_scale :: iScale = LinearScale()
end
