module JLDefault
using Bokeh
using Bokeh.Model.Dates
using Bokeh.Themes.JSON
using PythonCall

macro jldefault(type, code)
    :(function jldefault(T::Type{<:$type}, cls, prop)
        dflt = prop._default
        name = pyconvert(Symbol, dflt.__class__.__name__)
        if name ≡ :function
            dflt = dflt()
            name = pyconvert(Symbol, dflt.__class__.__name__)
        end

        (name ≡ :UndefinedType) && return nothing
        (name ≡ :NoneType) && return Some(nothing)

        mdl = pyconvert(String, dflt.__class__.__module__)
        if startswith(mdl, "bokeh.")
            return Some(Expr(:call, pyconvert(Symbol, dflt.__class__.__name__)))
        end
        $code
        return missing
    end)
end

@jldefault Bokeh.Model.EnumType (name ≡ :str) && return Some(pyconvert(Symbol, dflt))
@jldefault Vector{<:Union{String, Number}} return Some(pyconvert(T, dflt))

jldefault(::Type{Bokeh.Model.HatchPatternType}, cls, prop) = Some(:blank)

function jldefault(T::Union, cls, prop)
    dflt = prop._default
    name = pyconvert(Symbol, dflt.__class__.__name__)
    (name ≡ :UndefinedType) && return nothing
    (name ≡ :NoneType) && return Some(nothing)
    for eT ∈ Bokeh.Model.UnionIterator(T)
        opt = jldefault(eT, cls, prop)
        ismissing(opt) || return opt
    end
    return missing
end

struct _FakeProp
    _default::PythonCall.Py
end

@jldefault Tuple if name ≡ :tuple && length(dflt) ≡ length(T.parameters)
    out = [jldefault(eT, cls, _FakeProp(py)) for (py, eT) ∈ zip(dflt, T.parameters)]
    all(i isa Some for i ∈ out) && return Some(tuple(something.(out)...))
end

@jldefault Bokeh.Model.Nullable return jldefault(T.parameters[1], cls, prop)
@jldefault Bokeh.Model.ReadOnly return if T.parameters[1] isa Symbol
    Some(Expr(:call, T.parameters[1]))
else
    jldefault(T.parameters[1], cls, prop)
end

__DUMMY__ = let cls = @Bokeh.model mutable struct gensym() <: Bokeh.Model.iModel
        a :: Int
    end
    cls()
end

@jldefault Any begin
    for (i, j) ∈ (:str => String, :int => Int, :float => Float64, :bool => Bool)
        (name ≡ i) && return Some(pyconvert(j, dflt))
    end
    name ≡ :timedelta && return nothing
    name ∈ (:list, :dict, :set, :tuple) && isempty(dflt) && return nothing
    mdl = pyconvert(String, dflt.__class__.__module__)
    if startswith(mdl, "bokeh.")
        return Some(Expr(:call, pyconvert(Symbol, dflt.__class__.__name__)))
    end

    js = JSON.parse(pyconvert(String, pyimport("json").dumps(dflt)))
    return Bokeh.Model.bokehrawtype(
        Bokeh.Model.bokehread(T, __DUMMY__, :__dummy__, Bokeh.Model.bokehwrite(T, js))
    )
end
jldefault(::Symbol, cls, prop) = jldefault(Any, cls, prop)
end
