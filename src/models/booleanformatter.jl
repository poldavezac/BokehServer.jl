#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BooleanFormatter <: iBooleanFormatter

    icon :: Bokeh.Model.EnumType{(Symbol("check-square-o"), Symbol("check-circle"), :check, Symbol("check-circle-o"), Symbol("check-square"))} = :check

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
