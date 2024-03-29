#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#

@model mutable struct DataRange1d <: iDataRange1d

    bounds :: Union{Nothing, Model.MinMaxBounds} = nothing

    default_span :: Union{Float64, Dates.Period} = 2.0

    finish :: Union{Float64, Dates.DateTime, Dates.Period} = NaN

    flipped :: Bool = false

    follow :: Union{Nothing, Model.EnumType{(:start, :end)}} = nothing

    follow_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    only_visible :: Bool = false

    range_padding :: Union{Float64, Dates.Period} = 0.1

    range_padding_units :: Model.EnumType{(:percent, :absolute)} = :percent

    renderers :: Union{Model.EnumType{(:auto,)}, Vector{iModel}} = iModel[]

    start :: Union{Float64, Dates.DateTime, Dates.Period} = NaN
end
export DataRange1d
