#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
using BokehServer

const StyleSheets = Union{Dict{String, Union{BokehServer.Models.iStyles, Dict{String, Union{Nothing, String}}}}, String}

@BokehServer.model mutable struct Custom <: BokehServer.Models.iUIElement
    __implementation__ = "custom.ts"

    text :: String = "Custom text"
    slider  :: BokehServer.Models.Slider
    visible :: Bool = true
    classes :: Vector{String} = String[]
    styles :: Union{BokehServer.Models.iStyles, Dict{String, Union{Nothing, String}}} = Dict{String, Union{Nothing, String}}()
    stylesheets :: Vector{StyleSheets} = StyleSheets[]
end

BokehServer.serve() do doc
    slider = BokehServer.Models.Slider(start = 1., value = 10., finish = 20.)
    push!(doc, slider)
    push!(doc, Custom(;slider))
end
