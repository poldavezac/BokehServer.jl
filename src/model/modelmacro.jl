const _MODEL_ARGS = :(struct Model <: iModel
    js_event_callbacks :: Dict{Symbol, Vector{Bokeh.ModelTypes.iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{Bokeh.ModelTypes.iCustomJS}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}
end).args[end]

macro model(expr::Expr)
    append!(expr.args[end].args, _MODEL_ARGS.args)
    _👻code(__source__, __module__, expr)
end
export @model
