module Defaults
using ..Bokeh
using ..Bokeh.Model.Dates
using ..Bokeh.Themes.JSON
using PythonCall

modelsmap()  = pyimport("bokeh.models" => "Model").model_class_reverse_map
modelnames() = (pyconvert(String, i) for i ∈ modelsmap().keys())
model(name)  = name == "FigureOptions" ? pyimport("bokeh.plotting.figure" => name) : modelsmap()["$name"]

macro default(type, code)
    :(function parsedefault(T::Type{<:$type}, cls, attr::Symbol, prop)
        dflt = get(cls.__overridden_defaults__, "$attr", prop._default)
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

parsedefault(::Type{Bokeh.Model.HatchPatternType}, cls, ::Symbol, prop) = Some(:blank)
parsedefault(::Type{Bokeh.Model.HatchPatternSpec}, cls, ::Symbol, prop) = Some(:blank)

function parsedefault(T::Union, cls, attr::Symbol, prop)
    dflt = get(cls.__overridden_defaults__, "$attr", prop._default)
    name = pyconvert(Symbol, dflt.__class__.__name__)
    if name ≡ :function
        dflt = dflt()
        name = pyconvert(Symbol, dflt.__class__.__name__)
    end
    (name ≡ :UndefinedType) && return nothing
    (name ≡ :NoneType) && return Some(nothing)
    for eT ∈ Bokeh.Model.UnionIterator(T)
        opt = parsedefault(eT, cls, attr, prop)
        ismissing(opt) || return opt
    end
    return missing
end

struct _FakeProp
    _default::PythonCall.Py
end

@default Tuple if name ≡ :tuple && length(dflt) ≡ length(T.parameters)
    out = [parsedefault(eT, cls, attr, _FakeProp(py)) for (py, eT) ∈ zip(dflt, T.parameters)]
    all(i isa Some for i ∈ out) && return Some(tuple(something.(out)...))
end

@default Bokeh.Model.Nullable return parsedefault(T.parameters[1], cls, attr, prop)
@default Bokeh.Model.ReadOnly return if T.parameters[1] isa Symbol
    Some(Expr(:call, T.parameters[1]))
else
    parsedefault(T.parameters[1], cls, attr, prop)
end

__DUMMY__ = let cls = @Bokeh.wrap mutable struct gensym() <: Bokeh.Model.iModel
        a :: Int
    end
    cls()
end

@default Any begin
    name ≡ :timedelta && return nothing
    name ≡ :str && isempty(dflt) && return Some("")
    mdl = pyconvert(String, dflt.__class__.__module__)
    if startswith(mdl, "bokeh.")
        return _parsejson(dflt)
    end
    if name ≡ :list && !isempty(dflt) && startswith(pyconvert(String, dflt[0].__class__.__module__), "bokeh.")
        return Some(Expr(:vect, something.(_parsejson.(dflt))...))
    end

    try
        js  = JSON.parse(pyconvert(String, pyimport("json").dumps(dflt)))
        out = Bokeh.Model.bokehconvert(T, js)
        if !(out isa Bokeh.Model.Unknown)
            return Some(Bokeh.Model.bokehunwrap(Bokeh.Model.bokehread(T, __DUMMY__, :__dummy__, out)))
        end
    catch exc
        @error "Could not deal with default" T exception = (exc, Base.catch_backtrace())
    end
end
parsedefault(::Symbol, cls, attr::Symbol, prop) = parsedefault(Any, cls, attr, prop)

"given a bokeh object, find an expression to recreate it"
function _parsejson(obj::Py)
    cls  = pyconvert(Symbol, obj.__class__.__name__)
    dico = pyconvert(Dict, obj.to_json(false))
    pop!(dico, "id")
    isempty(dico) && return Some(Expr(:call, cls))

    for (i, j) ∈ collect(dico)
        dico[i] = if j isa Py && pyconvert(Symbol, j.__class__.__name__) ≡ :dict && haskey(j, "id")
            something(_parsejson(getproperty(obj, i)))
        else
            JSON.parse(pyconvert(String, pyimport("json").dumps(j)))
        end
    end
    return Some(Expr(:call, cls, Expr(:parameters, (Expr(:kw, Symbol(i), j) for (i, j) ∈ dico)...)))
end

end
