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
    getfield(hasfield(T, α) ? μ : getfield(μ, :original), α)
end

function Base.setproperty!(
        μ         :: T,
        α         :: Symbol,
        υ         :: Any;
        dotrigger :: Bool = true
) where {T <: iHasProps}
    return if hasfield(T, α)
        setfield!(μ, α, υ)
    else
        old = getproperty(μ, α)
        new = setfield!(getfield(μ, :original), α, υ)
        if dotrigger && (α ∈ bokehproperties(T))
            Bokeh.Events.trigger(Bokeh.ModelChangedEvent(μ, α, old, new))
        end
    end
end

function Base.getproperty(μ::T, α::Symbol) where {T <: iSourcedModel}
    if hasfield(T, α)
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
    return if hasfield(T, α)
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
        if dotrigger
            Bokeh.Events.trigger(Bokeh.ModelChangedEvent(μ, α, old, new))
        end
        new
    else
        setfield!(getfield(μ, :original), α, υ)
    end
end

Base.repr(mdl::T) where {T <: iHasProps} = "$T(id = $(bokehid(mdl)))" 
