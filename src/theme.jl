module Themes
using JSON
using ..Bokeh
using ..AbstractTypes
using ..Model

struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Function}}
    Theme() = new(Dict{Symbol, Dict{Symbol, Function}}())
end

const THEME = Theme()

function theme(T::Type, a...)
    doc = Bokeh.curdoc()
    return theme((isnothing(doc) ? THEME : doc.theme), T, a...)
end

function theme(dic::Theme, T::Type{<:iHasProps}, attr::Symbol)
    fcn = getvalue(dic, T, attr)
    return isnothing(fcn) ? nothing : Some(fcn())
end

function theme(dic::Theme, T::Type)
    isempty(dic.items) && return T()

    obj = T()
    for attr ∈ Model.bokehproperties(T)
        fcn = getvalue(dic, T, attr)
        isnothing(fcn) || setproperty!(obj, attr, fcn())
    end
    return obj
end

function changetheme!(obj::iHasProps, dic::Theme)
    isempty(dic.items) && return obj

    for attr ∈ Model.bokehproperties(typeof(obj))
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

    while cls ∉ (iHasProps, Any)
        key = nameof(cls)
        if key ∈ keys(attrtheme)
            return attrtheme[key]
        end
        cls = supertype(cls)
    end
end
end
using .Themes
