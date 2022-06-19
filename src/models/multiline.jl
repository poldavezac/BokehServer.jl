#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct MultiLine <: iMultiLine

    syncable :: Bool = true

    ys :: Bokeh.Model.Spec{Float64} = (field = "ys",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{Symbol}

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    xs :: Bokeh.Model.Spec{Float64} = (field = "xs",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
