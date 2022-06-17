module JLProp
using Bokeh
using Bokeh.Model.Dates
using Bokeh.Themes.JSON
try
    using Bokeh.Models
catch
    Bokeh.eval(:(module Models end))
end
using Bokeh.Models
using PythonCall
using ..JLDefault: jldefault, jlmodel, jlmodelnames
export jldefault, jlmodel, jlmodelnames

macro jlproperty(opt)
    others = nothing
    if opt isa Symbol
        type = opt
        name = Val{opt}
    else
        @assert opt.head ≡ :call && opt.args[1] ≡ :(=>)
        (types, type) = opt.args[2:end]
        name = types isa Expr ? Union{(Val{i} for i ∈ types.args)...} : Val{types}
    end
    (type isa Symbol) && (type = getfield(Bokeh.Model, type))
    :(function jlproperty(::$name, cls, prop)
        type    = $type
        doc     = pyis(prop.__doc__, @py(None)) ? nothing : pyconvert(String, prop.__doc__)
        default = jldefault(type, cls, prop)
        ismissing(default) && throw(ErrorException("unknown default $cls.$prop = $(prop._default)"))
        return (; type, default, doc)
    end)
end

_isenum(x) = pyconvert(Symbol, x.__class__.__name__) ∈ (:Enum, :Auto)

function _enum(objs...)
    vals = Symbol[]
    for i ∈ Iterators.filter(_isenum, objs), j ∈ i._enum._values
        x = pyconvert(Symbol, j)
        (x ∈ vals) || push!(vals, x)
    end
    Bokeh.Model.EnumType{tuple(vals...)}
end

function jlproperty(::Val{T}, cls, prop) where {T}
    type    = if T ∈ names(Bokeh.Model; all = true)
        getfield(Bokeh.Model, T)
    elseif endswith("$T", "Spec")
        Bokeh.Model.Spec{getfield(Bokeh.Model, Symbol("$T"[1:end-4]))}
    else
        throw(ErrorException("Cannot deal with python property `$T`"))
    end

    doc     = pyis(prop.__doc__, @py(None)) ? nothing : pyconvert(String, prop.__doc__)
    default = jldefault(type, cls, prop)
    ismissing(default) && throw(ErrorException("unknown default $cls.$prop = $(prop._default)"))
    return (; type, default, doc)
end

@jlproperty Date      => Date
@jlproperty Datetime  => DateTime
@jlproperty TimeDelta => Period
@jlproperty Bool
@jlproperty Regex
@jlproperty Int
@jlproperty String
@jlproperty MathString => String
@jlproperty Any
@jlproperty Float    => Float64
@jlproperty AnyRef   => Any
@jlproperty Null     => Nothing
@jlproperty ColumnData => DataDict
@jlproperty JSON => Bokeh.Model.JSONString
@jlproperty Dict     => Dict{jlproperty(cls, prop.keys_type).type, jlproperty(cls, prop.values_type).type}
@jlproperty (List, Seq, Array) => Vector{jlproperty(cls, prop.item_type).type}
@jlproperty Tuple    => Tuple{(jlproperty(cls, i).type for i ∈ prop._type_params)...}
@jlproperty Struct   => NamedTuple{
    tuple((pyconvert(Symbol, i) for i ∈ prop._fields.keys())...),
    Tuple{(jlproperty(cls, i).type for i ∈ prop._fields.values())...},
}
@jlproperty Instance => let cls  = if pyhasattr(prop._instance_type, "__name__")
        pyconvert(Symbol, prop._instance_type.__name__)
    else
        Symbol(split(pyconvert(String, prop._instance_type), '.')[end])
    end

    if cls ∉ names(Bokeh.Models; all = true)
        Bokeh.Models.eval(:(struct $cls end))
    end
    getfield(Bokeh.Models, cls)
end
@jlproperty Nullable => Bokeh.Model.Nullable{jlproperty(cls, prop.type_param).type}
@jlproperty Readonly => Bokeh.Model.ReadOnly{jlproperty(cls, prop.type_param).type}
@jlproperty Enum     => Bokeh.Model.EnumType{tuple(Set([pyconvert(Symbol, j) for j ∈ prop._enum._values])...)}
@jlproperty Either   => let enu = (; type = _enum((i for i ∈ prop._type_params)...))
    types = NamedTuple[(jlproperty(cls, i) for i ∈ prop._type_params if !_isenum(i))...]
    if isempty(types)
        @assert !isempty(values(enu.type))
        enu.type
    else
        isempty(values(enu.type)) || insert!(types, 1, enu)

        hasnull = any(isnothing(i) for i ∈ types)
        hasnull && filter!(!isnothing, type)
        out = length(types) == 1 ? types[1].type : Union{(i.type for i ∈ types)...}
        hasnull ? Nullable{out} : out
    end
end
@jlproperty RestrictedDict => Dict{
    Bokeh.Model.RestrictedKey{tuple((pyconvert(Symbol, i) for i ∈ prop._disallow)...)},
    jlproperty(cls, prop.values_type).type
}

jlproperty(::Val{:NonNullable}, cls, prop) = merge(jlproperty(cls, prop.type_param), (; default = nothing))

for name ∈ names(Bokeh.Model; all = true)
    𝑃 = getfield(Bokeh.Model, name)
    ((𝑃 isa DataType) && (𝑃 <: Bokeh.Model.iProperty)) || continue
    @eval @jlproperty $(name)
end

jlproperty(cls, prop) = jlproperty(Val(pyconvert(Symbol, prop.__class__.__name__)), cls, prop)
jlproperty(c::Symbol, p::Symbol) = jlproperty(jlmodel("$c"), getproperty(jlmodel("$c"), p).property)

jlproperties(name) = jlproperties(jlmodel(name))

function jlproperties(cls::Py)
    attrs = Dict(
        pyconvert(Symbol, attr) => try
            jlproperty(cls, getproperty(cls, pyconvert(String, attr)).property)
        catch exc
            @error(
                "Could not deal with $cls.$attr => $(getproperty(cls, pyconvert(String, attr)).property)",
                exception = (exc, Base.catch_backtrace())
            )

            rethrow()
        end
        for attr ∈ cls.properties()
    )
end
export jlproperty, jlproperties
end

using .JLProp
