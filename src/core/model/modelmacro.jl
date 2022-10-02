macro model(expr::Expr)
    cls = if isdefined(__module__, :iCallback)
        getfield(__module__, :iCallback)
    elseif isdefined(__module__, :BokehServer)
        getfield(__module__, :BokehServer).Models.iCallback
    end
    args = [
        :(js_event_callbacks    :: Dict{String, Vector{$cls}}),
        :(js_property_callbacks :: Dict{String, Vector{$cls}}),
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
