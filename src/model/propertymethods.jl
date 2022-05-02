for (tpe, others) ∈ (iHasProps => (), iSourcedModel => (:data_source,)) 
    @eval function Base.propertynames(μ::$tpe; private::Bool = false)
        return if private
            (propertynames(getfield(μ, :original))..., fieldnames(μ)..., $(Meta.quot.(others)...), :id)
        else
            (propertynames(getfield(μ, :original))..., $(Meta.quot.(others)...))
        end
    end
end

function Base.getproperty(μ::T, α::Symbol) where {T <: iHasProps}
    getfield(α ∈ fieldnames(T) ? μ : getfield(μ, :original), α)
end

function Base.setproperty!(
        μ         :: T,
        α         :: Symbol,
        υ         :: Any;
        dotrigger :: Bool = true
) where {T <: iHasProps}
    return if α ∈ fieldnames(T)
        setfield!(μ, α, υ)
    else
        old = getproperty(μ, α)
        new = setfield!(getfield(μ, :original), α, υ)
        dotrigger && (α ∈ bokehproperties(T)) && Bokeh.Events.trigger(μ, α, old, new)
    end
end

function Base.getproperty(μ::T, α::Symbol) where {T <: iSourcedModel}
    if α ∈ fieldnames(T)
        return getfield(μ, α)
    elseif α ≡ :data_source
        return getfield(μ, :source).source
    elseif hasfield(fieldtype(T, :source), α)
        src = getfield(getfield(μ, :source), α)
        isnothing(src) || return Column(src)
    end
    return getfield(getfield(μ, :original), α)
end

function Base.setproperty!(
        μ         :: T,
        α         :: Symbol,
        υ         :: Any;
        dotrigger :: Bool = true
) where {T <: iSourcedModel}
    return if α ∈ fieldnames(T)
        setfield!(μ, α, υ)
    elseif α ≡ :data_source
        setfield!(getfield(μ, :source), :source, υ)
    elseif hasfield(fieldtype(T, :source), α)
        old = getproperty(μ, α)
        new = if μ isa Column
            setfield!(getfield(μ, :source), α, υ.column)
        else
            setfield!(getfield(μ, :source), α, nothing)
            setfield!(getfield(μ, :original), α, υ)
        end
        dotrigger && Bokeh.Events.trigger(μ, α, old, new)
        new
    else
        setfield!(getfield(μ, :original), α, υ)
    end
end
