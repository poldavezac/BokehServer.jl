#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@Bokeh.wrap mutable struct BoxEditTool <: iBoxEditTool

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    renderers :: Vector{iGlyphRenderer}

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end
