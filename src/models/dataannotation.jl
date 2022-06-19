#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DataAnnotation <: iDataAnnotation

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()
end
