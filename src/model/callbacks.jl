function removecallback!(model::iModel, attr::Symbol, func::Function)
    filter!(getfield(getfield(model, :callbacks), attr)) do opt
        func ≢ opt
    end
end

function removecallback!(model::iModel, attr::Symbol, id::Int64)
    filter!(getfield(getfield(model, :callbacks), attr)) do opt
        func ≢ opt
    end
end

function addcallback!(model::T, attr::Symbol, func::Function) where {T <: iModel}
    cb = getfield(getfield(model, :callbacks), attr)
    (func ∈ cb) && return nothing
    for method ∈ methods(func)
        params = method.sig.parameters
        if length(params) ≥ 5 && T <: params[2] && Symbol <: params[3]
            push!(cb, func)
            return func
        end
    end
    sig = "$(nameof(func))(::<:$T, ::<:Symbol, ::<:Any, ::<:Any)"
    throw(KeyError("No correct signature: should be $sig"))
end

macro addcallback!(elems...)
    args  = (; (i => i for i ∈ (:attribute, :old, :new))...)
    model = :model
    attr  = nothing
    body  = nothing
    for itm ∈ elems
        itm isa Expr || error("Unknown argument `$itm` in macro `@Bokeh.addcallback!`")

        if itm.head ≡ :(=) && itm.args[1] ∈ keys(args)
            merge(args, (; (itm.args[1] => itm.args[2],)...))
        elseif itm.head ≡ :. && itm.args[1] isa Symbol && itm.args[2] isa QuoteNode
            model = itm.args[1]
            attr  = itm.args[2].value
        else
            body = Expr(:block, itm)
        end
    end

    isnothing(attr) && error("Missing argument `obj.attr` in macro `@Bokeh.addcallback!`")
    isnothing(body) && error("Missing argument `body` in macro `@Bokeh.addcallback!`")

    sig  = [Expr(:(::), i, j) for (i,j) ∈ zip(values(args), (Symbol, Any, Any))]

    # not using addcallback! as the signature verifications are pointless
    esc(quote
        let func = function($model :: Bokeh.iModel, $(sig...))
                $body
            end
            cb   = getfield(getfield($model, :callbacks), $(Meta.quot(attr)))
            push!(cb, func)
            func
        end
    end)
end

export removecallback!, addcallback!, @addcallback!
