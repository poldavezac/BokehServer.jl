module Defaults
using Bokeh
using Bokeh.Model.Dates
using Bokeh.Themes.JSON
using PythonCall

model(name)  = pyimport("bokeh.models" => "Model").model_class_reverse_map["$name"]
modelnames() = (pyconvert(String, i) for i ∈ pyimport("bokeh.models" => "Model").model_class_reverse_map.keys())

macro default(type, code)
    :(function parsedefault(T::Type{<:$type}, cls, prop)
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

@default Bokeh.Model.EnumType (name ≡ :str) && return Some(pyconvert(Symbol, dflt))
@default Vector{<:Union{String, Number}} return Some(pyconvert(T, dflt))

parsedefault(::Type{Bokeh.Model.HatchPatternType}, cls, prop) = Some(:blank)

function parsedefault(T::Union, cls, prop)
    dflt = prop._default
    name = pyconvert(Symbol, dflt.__class__.__name__)
    (name ≡ :UndefinedType) && return nothing
    (name ≡ :NoneType) && return Some(nothing)
    for eT ∈ Bokeh.Model.UnionIterator(T)
        opt = parsedefault(eT, cls, prop)
        ismissing(opt) || return opt
    end
    return missing
end

struct _FakeProp
    _default::PythonCall.Py
end

@default Tuple if name ≡ :tuple && length(dflt) ≡ length(T.parameters)
    out = [parsedefault(eT, cls, _FakeProp(py)) for (py, eT) ∈ zip(dflt, T.parameters)]
    all(i isa Some for i ∈ out) && return Some(tuple(something.(out)...))
end

@default Bokeh.Model.Nullable return parsedefault(T.parameters[1], cls, prop)
@default Bokeh.Model.ReadOnly return if T.parameters[1] isa Symbol
    Some(Expr(:call, T.parameters[1]))
else
    parsedefault(T.parameters[1], cls, prop)
end

__DUMMY__ = let cls = @Bokeh.model mutable struct gensym() <: Bokeh.Model.iModel
        a :: Int
    end
    cls()
end

@default Any begin
    name ≡ :timedelta && return nothing
    name ∈ (:list, :dict, :set, :tuple) && isempty(dflt) && return nothing
    name ≡ :str && isempty(dflt) && return Some("")
    mdl = pyconvert(String, dflt.__class__.__module__)
    if startswith(mdl, "bokeh.")
        return Some(Expr(:call, pyconvert(Symbol, dflt.__class__.__name__)))
    end

    js = JSON.parse(pyconvert(String, pyimport("json").dumps(dflt)))
    return Some(Bokeh.Model.bokehrawtype(
        Bokeh.Model.bokehread(T, __DUMMY__, :__dummy__, Bokeh.Model.bokehwrite(T, js))
    ))
end
parsedefault(::Symbol, cls, prop) = parsedefault(Any, cls, prop)
end
