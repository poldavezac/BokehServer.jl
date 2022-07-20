module Themes
using JSON
using ..BokehJL
using ..AbstractTypes
using ..Model

"""
A structure containing theme defaults
"""
struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Function}}
    Theme() = new(Dict{Symbol, Dict{Symbol, Function}}())
end

"""
THEME :: Theme: the default theme
"""
const THEME = Theme()

function theme(T::Type, a...)
    doc = BokehJL.curdoc()
    return theme((isnothing(doc) ? THEME : doc.theme), T, a...)
end

"""
    theme([dic::Theme,] T::Type{<:iHasProps}, attr::Symbol)

Return, for type `T`'s field `attr`, the `Some`-wrapped theme default or nothing
"""
function theme(dic::Theme, T::Type{<:iHasProps}, attr::Symbol)
    fcn = getvalue(dic, T, attr)
    return isnothing(fcn) ? nothing : Some(fcn())
end

"""
    theme([dic::Theme,] T::Type)

Creates a default object given the (current) theme
"""
function theme(dic::Theme, T::Type)
    isempty(dic.items) && return T()

    return T(;(
        attr => something(fcn)()
        for fcn ∈ (
            getvalue(dic, T, attr) for attr ∈ Model.bokehproperties(T)
        ) if !isnothing(fcn)
    )...)
end

"""
    changetheme!(obj::iHasProps, dic::Theme)

Updates `obj` such that it now conforms to theme `dic`
"""
function changetheme!(obj::iHasProps, dic::Theme)
    isempty(dic.items) && return obj

    for attr ∈ Model.bokehproperties(typeof(obj))
        fcn = getvalue(dic, typeof(obj), attr)
        isnothing(fcn) || setproperty!(obj, attr, fcn())
    end
    return obj
end

"""
    read!(dic::Theme, io::IO; empty::Bool = true)
    read!(dic::Theme, path::String; empty::Bool = true)

Applies a JSON theme file to the `dic`
"""
function read!(dic::Theme, path::String; empty::Bool = true)
    open(((io)->read!(dic, io; empty)), path)
end

function read!(dic::Theme, io::IO; empty::Bool = true)
    empty && empty!(dic.items)
    for (cls, attrs) ∈ JSON.parse(io), (attr, val) ∈ attrs
        setvalue!(dic, Symbol(cls), Symbol(attr), ()->copy(val))
    end
end

"""
    setvalue!(dic::Theme, cls::Symbol, attr::Symbol, val::Function)

Adds a default value function `val` to theme `dic` for type `cls` and field `attr`
"""
function setvalue!(dic::Theme, cls::Symbol, attr::Symbol, val::Function)
    get!(Dict{Symbol, Any}, dic.items, attr)[cls] = val
end

"""
    getvalue(dic::Theme, cls::Type, attr::Symbol) :: Union{Function, Nothing}

Retrieves a default value function from theme `dic` for type `cls` and field `attr`.
This is done by looking through all supertypes for `cls`
"""
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
