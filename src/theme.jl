module Themes
using JSON
using ..Bokeh
using ..AbstractTypes
using ..Models

struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Function}}
    Theme() = new(Dict{Symbol, Dict{Symbol, Function}}())
end

function theme(T::Type, _...)
    doc = Bokeh.curdoc()
    return isnothing(doc) ? T() : theme(doc.theme, T, _...)
end

function theme(dic::Theme, T::Type{<:iModel}, attr::Symbol)
    if !isempty(dic.items)
        fcn = getvalue(dic, T, attr)
        isnothing(fcn) || return Some(fcn())
    end
    return nothing
end

function theme(dic::Theme, T::Type{<:iModel}, props::Dict{Symbol, Any})
    isempty(dic.items) && return props

    for attr ∈ Models.bokehproperties(T)
        if !haskey(props, attr)
            fcn = getvalue(dic, T, attr)
            isnothing(fcn) || props[attr] = fcn()
        end
    end
    return props
end

function theme(dic::Theme, T::Type)
    isempty(dic.items) && return T()

    obj = T()
    for attr ∈ Models.bokehproperties(T)
        fcn = getvalue(dic, T, attr)
        isnothing(fcn) || setproperty!(obj, attr, fcn())
    end
    return obj
end

function changetheme!(obj::iHasProps, dic::Theme)
    isempty(dic.items) && return obj

    for attr ∈ Models.bokehproperties(typeof(obj))
        fcn = getvalue(dic, typeof(obj), attr)
        isnothing(fcn) || setproperty!(obj, attr, fcn())
    end
    return obj
end

function read!(dic::Theme, path::String; empty::Bool = true)
    open(((io)->read!(dic, io; empty)), path)
end

function read!(dic::Theme, io::IO; empty::Bool = true)
    empty && empty!(dic.items)
    for (cls, attrs) ∈ JSON.parse(io), (attr, val) ∈ attrs
        setvalue!(dic, Symbol(cls), Symbol(attr), ()->copy(val))
    end
end

function setvalue!(dic::Theme, cls::Symbol, attr::Symbol, val::Function)
    get!(Dict{Symbol, Any}, dic.items, attr)[cls] = val
end

function getvalue(dic::Theme, cls::Type, attr::Symbol) :: Union{Function, Nothing}
    attrtheme = get(dic.items, attr, nothing)
    isnothing(attrtheme) && return nothing

    while cls ∉ (iModel, iSourcedModel, iDataSource, Any)
        key = nameof(cls)
        if key ∈ keys(attrtheme)
            return attrtheme[key]
        end
        cls = supertype(cls)
    end
end
end
using .Themes
