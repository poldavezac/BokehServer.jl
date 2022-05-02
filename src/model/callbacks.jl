function removecallback!(model::T, attr::Symbol, func::Function) where {T <: iModel}
    filter!(getfield(getfield(model, :callbacks), attr)) do opt
        func ≢ opt
    end
end

function addcallback!(model::T, attr::Symbol, func::Function) where {T <: iModel}
    cb = getfield(getfield(model, :callbacks), attr)
    if func ∈ cb
        return false
    elseif any(
        let params = method.sig.parameters
            length(params) ≥ 5 && T <: params[2] && Symbol <: params[3]
        end
        for method ∈ methods(func)
    )
        push!(cb, func)
        return true
    else
        sig = "$(nameof(func))(::<:$T, ::<:Symbol, ::<:Any, ::<:Any)"
        throw(KeyError("No correct signature: should be $sig"))
    end
end

export removecallback! addcallback!
