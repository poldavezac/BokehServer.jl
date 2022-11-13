module Defaults
using PythonCall
using ..BokehServer
using ..BokehServer.Model.Dates
using ..BokehServer.Themes.JSON
using ..CodeCreator: modelnames, modelsmap

function _getdefaultandname(cls, attr, prop)
    dflt = get(cls.__overridden_defaults__, "$attr", prop._default)
    name = pyconvert(Symbol, dflt.__class__.__name__)

    if name ≡ :function
        dflt = dflt()
        name = pyconvert(Symbol, dflt.__class__.__name__)
    end
    return (dflt, name)
end


macro default(type, code)
    :(function parsedefault(T::Type{<:$type}, cls, attr::Symbol, prop)
        (dflt, name) = _getdefaultandname(cls, attr, prop)
        applicable(_parsedefault, Val(name), dflt) && return _parsedefault(Val(name), dflt)

        $code
        return missing
    end)
end

_parsedefault(::Val{:UndefinedType}, _...) = nothing
_parsedefault(::Val{:NoneType}, _...)      = Some(nothing)
_parsedefault(::Val{:timedelta}, _...)     = nothing
_parsedefault(::Val{:bytes}, dflt)         = Some(pyconvert(Vector{UInt8}, dflt))

function _parsedefault(::Val{:InstanceDefault}, dflt)
    name = pyconvert(Symbol, dflt._model.__name__)
    kwa  = JSON.parse(pyconvert(String, pyimport("json").dumps(dflt._kwargs)))
    return Some(Expr(:call, name, (Expr(:kw, Symbol(i), j) for (i, j) ∈ kwa)...))
end

@default BokehServer.Model.EnumType (name ≡ :str) && return Some(pyconvert(Symbol, dflt))
@default Vector{<:Union{String, Number}} return Some(pyconvert(T, dflt))

parsedefault(::Type{BokehServer.Model.HatchPatternType}, cls, ::Symbol, prop) = Some(:blank)
parsedefault(::Type{BokehServer.Model.HatchPatternSpec}, cls, ::Symbol, prop) = Some(:blank)

function parsedefault(T::Union, cls, attr::Symbol, prop)
    (dflt, name) = _getdefaultandname(cls, attr, prop)
    applicable(_parsedefault, Val(name), dflt) && return _parsedefault(Val(name), dflt)
    for eT ∈ BokehServer.Model.UnionIterator(T)
        opt = parsedefault(eT, cls, attr, prop)
        ismissing(opt) || return opt
    end
    return missing
end

struct _FakeProp
    _default::PythonCall.Py
end

@default BokehServer.Model.StringSpec begin
    return if name ≡ :Value
         (; value = pyconvert(String, dflt.value))
    elseif name ≡ :Field
        (; field = pyconvert(String, dflt.field))
    elseif name ≡ :str
        val = pyconvert(String, dflt)
        "$attr" ≡ val ? (; field = val) : (; value = val)
    else
        throw(ErrorException("Not implemented: $name $dflt"))
    end
end

@default Tuple if name ≡ :tuple && length(dflt) ≡ length(T.parameters)
    out = [parsedefault(eT, cls, attr, _FakeProp(py)) for (py, eT) ∈ zip(dflt, T.parameters)]
    all(i isa Some for i ∈ out) && return Some(tuple(something.(out)...))
end

@default BokehServer.Model.ReadOnly return if T.parameters[1] isa Symbol
    Some(Expr(:call, T.parameters[1]))
else
    parsedefault(T.parameters[1], cls, attr, prop)
end

__DUMMY__ = let cls = @BokehServer.wrap mutable struct gensym() <: BokehServer.Model.iModel
        a :: Int
    end
    cls()
end

@default Any begin
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
        out = BokehServer.Model.bokehconvert(T, js)
        if !(out isa BokehServer.Model.Unknown)
            return Some(BokehServer.Model.bokehunwrap(BokehServer.Model.bokehread(T, __DUMMY__, :__dummy__, out)))
        end
    catch exc
        @error "Could not deal with default" T exception = (exc, Base.catch_backtrace())
    end
end
parsedefault(::Symbol, cls, attr::Symbol, prop) = parsedefault(Any, cls, attr, prop)

"given a bokeh object, find an expression to recreate it"
function _parsejson(obj::Py)
    cls  = pyconvert(Symbol, obj.__class__.__name__)
    dico = pyconvert(Dict{String, Any}, obj.to_serializable(pyimport("bokeh.core.serialization").Serializer()))
    expr = Expr(:call, cls)
    if get(dico, "type", nothing) ∈ ("field", "value", "expr")
        @assert length(dico) == 2
        return Some(dico[dico["type"]])
    elseif haskey(dico, "attributes")
        dico = pyconvert(Dict{String, Any}, dico["attributes"])
        for (i, j) ∈ collect(dico)
            dico[i] = if j isa Py && pyconvert(Symbol, j.__class__.__name__) ≡ :dict && haskey(j, "id")
                something(_parsejson(getproperty(obj, i)))
            else
                JSON.parse(pyconvert(String, pyimport("json").dumps(j)))
            end
        end
        push!(expr.args, Expr(:parameters, (Expr(:kw, Symbol(i), j) for (i, j) ∈ dico)...))
    end
    return Some(expr)
end

end
