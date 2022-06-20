#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct DataRange1d <: iDataRange1d

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    default_span :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    finish :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    flipped :: Bool = false

    follow :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:start, :end)}} = nothing

    follow_interval :: Bokeh.Model.Nullable{Union{Float64, Dates.Period}} = nothing

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    only_visible :: Bool = false

    range_padding :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iModel}}

    start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
