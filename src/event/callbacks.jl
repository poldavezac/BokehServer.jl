function hasparameters(func::Function, args...)
    return any(
        let params = method.sig.parameters
            length(params) ≡ length(args)+1 && all(
                args[i] <: params[i+1] || params[i+1] <: args[i]
                for i ∈ eachindex(args)
            )
        end
        for method ∈ methods(func)
    )
end

function onchange(func::Function, model::iDocument)
    cb = getfield(model, :callbacks)
    (func ∈ cb) && return nothing

    if hasparameters(func, iDocumentEvent)
        params = Set([
            method.sig.parameters[2]
            for method ∈ methods(func)
            if let params = method.sig.parameters
                length(params) ≡ 2 && (params[2] <: iEvent || iEvent <: params[2])
            end
        ])
        return if any(i ∈ params for i ∈ (Any, iEvent, iDocumentEvent))
            push!(cb, func)
            func
        else
            uni  = length(params) == 1 ? first(params) : Union{params...}
            wrap = (e::iDocumentEvent) -> (e isa uni) && func(e)
            push!(cb, wrap)
            wrap
        end
    else
        throw(KeyError("""
            No correct signature. It should be:
            * function (::<:iDocumentEvent)
        """))
    end
end

function onchange(func::Function, model::iModel)
    cb = getfield(model, :callbacks)
    return if func ∈ cb
        nothing
    elseif hasparameters(func, ModelChangedEvent)
        push!(cb, func)
        func
    elseif hasparameters(func, iModel, Symbol, Any, Any)
        wrap = (e::ModelChangedEvent) -> func(e.model, e.attr, e.old, e.new)
        push!(cb, wrap)
        wrap
    else
        throw(KeyError("""
            No correct signature. It should be:
            * function (::ModelChangedEvent)
            * function (obj::iModel, attr::Symbol, old::Any, new::Any)
        """))
    end
end

export onchange
