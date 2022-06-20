#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@wrap mutable struct Arrow <: iArrow

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    finish :: Bokeh.Model.Nullable{iArrowHead} = OpenHead()

    finish_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

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

    name :: Bokeh.Model.Nullable{String} = nothing

    source :: iDataSource = ColumnDataSource()

    start :: Bokeh.Model.Nullable{iArrowHead} = nothing

    start_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    visible :: Bool = true

    x_end :: Bokeh.Model.Spec{Float64} = (field = "x_end",)

    x_range_name :: String = "default"

    x_start :: Bokeh.Model.Spec{Float64} = (field = "x_start",)

    y_end :: Bokeh.Model.Spec{Float64} = (field = "y_end",)

    y_range_name :: String = "default"

    y_start :: Bokeh.Model.Spec{Float64} = (field = "y_start",)
end
