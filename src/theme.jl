module Themes
using JSON
using ..Bokeh
using ..AbstractTypes
using ..Models

struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Any}}
    Theme() = new(Dict{Symbol, Dict{Symbol, Any}}())
end

function theme(T::Type)
    doc = Bokeh.curdoc()
    return isnothing(doc) || isnothing(doc.theme) ? T() : theme(doc.theme, T())
end

function theme(dic::Theme, T::Type)
    @assert Models.modeltype(T) <: iModel
    isempty(dic.items) && return T()

    themed = dic.items
    obj    = T()
    for attr ∈ Models.bokehproperties(Models.modeltype(T))
        attrtheme = get(themed, attr, nothing)
        isnothing(attr) && continue

        curcls   = T
        while curcls ∉ (iModel, iSourcedModel, iDataSource)
            if nameof(curcls) ∈ keys(attrtheme)
                setproperty!(obj, attr, attrtheme[nameof(curcls)])
                break
            end
            curcls   = supertype(T)
        end
    end
    return obj
end

function read!(dic::Theme, path::String; empty::Bool = true)
    empty && empty!(dic.items)
    for (cls, attrs) ∈ JSON.parse(path), (attr, val) ∈ attrs
        get!(Dict{Symbol, Any}, dic.items, Symbol(cls))[Symbol(attr)] = val
    end
end

end
using .Themes
