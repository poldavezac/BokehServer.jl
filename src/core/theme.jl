module Themes
using JSON
using Pkg.Artifacts
using ..BokehServer
using ..AbstractTypes
using ..Model

"""
A structure containing theme defaults.

One can create a theme by providing a path to a JSON file
or the name of a *python bokeh* theme.
"""
struct Theme <: iTheme
    items :: Dict{Symbol, Dict{Symbol, Any}}
end

Theme() = Theme(Dict{Symbol, Dict{Symbol, Any}}())
Theme(name::Union{AbstractString, Symbol}) = read!(Theme(), name)

"""
THEME :: Theme: the default theme
"""
const THEME = Theme()

function theme(T::Type, a...)
    @nospecialize T a
    doc = BokehServer.curdoc()
    return theme((isnothing(doc) ? THEME : doc.theme), T, a...)
end

"""
    theme([dic::Theme,] T::Type, attr::Symbol)

Retrieves a default value from theme `dic` for type `cls` and field `attr`.
This is done by looking through all supertypes for `cls`
"""
function theme(dic::Theme, @nospecialize(cls::Type), attr::Symbol) :: Union{Some, Nothing}
    attrtheme = get(dic.items, attr, nothing)
    isnothing(attrtheme) && return nothing

    while cls ∉ (iHasProps, Any)
        key = if isabstracttype(cls)
            k = "$(nameof(cls))"
            # get rid of pesky 'i' in abstract types
            k[1] ≡ 'i' ? Symbol(k[2:end]) : nameof(cls)
        else
            nameof(cls)
        end
            
        if key ∈ keys(attrtheme)
            val = attrtheme[key]
            return Some(if val isa Union{AbstractString, Symbol} || isimmutable(val)
                val
            else
                copy(val)
            end)
        end
        cls = supertype(cls)
    end
    return nothing
end

"""
    theme([dic::Theme,] T::Type)

Creates a default object given the (current) theme
"""
function theme(dic::Theme, T::Type)
    isempty(dic.items) && return T()

    return T(;(
        i => something(j)
        for (i, j) ∈ (k => theme(dic, T, k) for k ∈ Model.bokehproperties(T))
        if !isnothing(j)
    )...)
end

"""
    changetheme!(obj::iHasProps, dic::Theme)

Updates `obj` such that it now conforms to theme `dic`
"""
function changetheme!(obj::iHasProps, dic::Theme)
    isempty(dic.items) && return obj
 
    for attr ∈ Model.bokehproperties(typeof(obj))
        val = theme(dic, typeof(obj), attr)
        isnothing(val) || setproperty!(obj, attr, something(val))
    end
    return obj
end

"""
    read!(dic::Theme, io::IO; empty::Bool = true)
    read!(dic::Theme, path::AbstractString; empty::Bool = true)
    read!(dic::Theme, name::Symbol)

Applies a JSON or python theme file to the `dic`.

Symbols can be :caliber, :contrast, :dark_minimal, :light_minimal, :night_sky and 
correspond to *python bokeh* options
"""
function read!(dic::Theme, path::AbstractString; empty::Bool = true)
    if endswith(path, ".py")
        io = IOBuffer()
        # Parse a python file.
        # We expect some indentations as in bokeh/themes/_caliber.py
        open(path) do stream
            started = false
            for line ∈ eachline(stream)
                (isempty(line) || line[1] ∈ ('#', '}')) && continue
                if !started
                    started = occursin("\"attrs\":", line)
                    started && print(io, "{")
                else
                    print(io, strip(line))
                end
            end
        end
        read!(dic, IOBuffer(replace(String(take!(io)), ",}" => "}")); empty)
    else
        open(((io)->read!(dic, io; empty)), path)
    end
    return dic
end

function read!(dic::Theme, name::Symbol)
    empty!(dic.items)
    if name ≡ :current
        # just copy the current state
        merge!(dic.items, deepcopy(THEME.items))
    elseif name ≢ :default
        # get the python bokeh values
        read!(dic, joinpath(artifact"javascript", "site-packages", "bokeh", "themes", "_$name.py"))
    end
    return dic
end

function read!(dic::Theme, io::IO; empty::Bool = true)
    empty && empty!(dic.items)
    for (cls, attrs) ∈ JSON.parse(io), (attr, val) ∈ attrs
        setvalue!(dic, Symbol(cls), Symbol(attr), val)
    end
    return dic
end

"""
    setvalue!([dic::Theme = THEME,] cls::Symbol, attr::Symbol, val)

Adds a default value function `val` to theme `dic` for type `cls` and field `attr`
"""
function setvalue!(dic::Theme, cls::Symbol, attr::Symbol, val)
    get!(Dict{Symbol, Any}, dic.items, attr)[cls] = val
end

setvalue!(cls::Symbol, attr::Symbol, val) = setvalue!(THEME, cls, attr, val) 

"""
    setvalues!([theme::Theme = THEME,] name::Union{AbstractString, Symbol, AbstractDict, Nothing})

Sets the generic theme to new values
"""
setvalues!(theme::Theme, name::Union{AbstractString, Symbol}) = read!(theme, name)
setvalues!(theme::Theme, name::AbstractDict) = (empty!(theme.items),  merge!(theme.items, name))
setvalues!(name) = setvalues!(THEME, name)

"""
    setvalues!(𝐹::Function, [theme::Theme = THEME,] name)

Sets the theme to new values for the duration of `𝐹`.

*Note* This is not thread-safe.
"""
function setvalues!(𝐹::Function, theme::Theme, name)
    old = copy(THEME.items)
    try
        setvalues!(theme, name)
        𝐹()
    finally
        setvalues!(theme, old)
    end
end
setvalues!(𝐹::Function, name) = setvalues!(𝐹, THEME, name)

end
using .Themes
