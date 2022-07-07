function _👻modelalgs(mdl)
end

macro model(expr::Expr)
    cls = if isdefined(__module__, :iCustomJS)
        getfield(__module__, :iCustomJS)
    elseif isdefined(__module__, :BokehJL)
        getfield(__module__, :BokehJL).Models.iCustomJS
    end
    args = [
        :(js_event_callbacks    :: Dict{Symbol, Vector{$cls}}),
        :(js_property_callbacks :: Dict{Symbol, Vector{$cls}}),
        :(name                  :: Union{Nothing, String} = nothing),
        :(subscribed_events     :: Vector{Symbol}),
        :(syncable              :: Bool = true),
        :(tags                  :: Vector{Any})
    ]
    append!(expr.args[end].args, args)
    _👻code(__source__, __module__, expr)
end
export @model
precompile(Tuple{var"#@model", LineNumberNode, Module, Expr})
