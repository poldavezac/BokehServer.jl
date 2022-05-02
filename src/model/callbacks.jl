function removecallback!(model::iModel, attr::Symbol, func::Function)
    filter!(getfield(getfield(model, :callbacks), attr)) do opt
        func ≢ opt
    end
end

function addcallback!(model::iModel, attr::Symbol, func::Function)
    cb = getfield(getfield(model, :callbacks), attr)
    if (func ∈ cb)
       return nothing
    elseif any(length(m.sig.parameters) ≥ 5 for m ∈ methods(func))
        push!(cb, func)
    else
        sig = "$(nameof(func))(::<:$T, ::<:Symbol, ::<:Any, ::<:Any)"
        throw(KeyError("No correct signature: should be $sig"))
    end
    return func
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
            Bokeh.addcallback!($model, $(Meta.quot(attr)), func)
        end
    end)
end
