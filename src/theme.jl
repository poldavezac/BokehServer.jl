module Themes
using JSON
using ..Bokeh
using ..AbstractTypes
using ..Models

struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Function}}
    Theme() = new(Dict{Symbol, Dict{Symbol, Function}}())
end

function theme(T::Type)
    doc = Bokeh.curdoc()
    return isnothing(doc) ? T() : theme(doc.theme, T)
end

function theme(dic::Theme, T::Type)
    bkT = Models.modeltype(T)
    if !(bkT <: iModel)
        T, bkT = bkT, T
    end

    isempty(dic.items) && return T()

    obj = T()
    for attr ∈ Models.bokehproperties(bkT)
        fcn = getvalue(dic, bkT, attr)
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
