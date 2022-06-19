#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Whisker <: iWhisker

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    lower_head :: Bokeh.Model.Nullable{iArrowHead} = TeeHead()

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    name :: Bokeh.Model.Nullable{String} = nothing

    source :: iDataSource = ColumnDataSource()

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    upper_head :: Bokeh.Model.Nullable{iArrowHead} = TeeHead()

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    visible :: Bool = true

    x_range_name :: String = "default"

    y_range_name :: String = "default"
end
