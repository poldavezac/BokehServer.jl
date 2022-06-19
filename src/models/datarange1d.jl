#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct DataRange1d <: iDataRange1d

    syncable :: Bool = true

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iModel}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    tags :: Vector{Any}

    follow_interval :: Bokeh.Model.Nullable{Union{Float64, Dates.Period}} = nothing

    range_padding :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{Symbol}

    finish :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    only_visible :: Bool = false

    default_span :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    follow :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:start, :end)}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    names :: Vector{String} = String[]

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    flipped :: Bool = false

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
