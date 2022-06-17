module JLProp
using Bokeh
using Bokeh.Model.Dates
using Bokeh.Themes.JSON
using PythonCall
using ..JLDefault: jldefault

struct Instance{T} end

macro jlprop(opt)
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
    :(function jlprop(::$name, cls, prop)
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

function jlprop(::Val{T}, cls, prop) where {T}
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

@jlprop Date      => Date
@jlprop Datetime  => DateTime
@jlprop TimeDelta => Period
@jlprop Bool
@jlprop Regex
@jlprop Int
@jlprop String
@jlprop MathString => String
@jlprop Any
@jlprop Float    => Float64
@jlprop AnyRef   => Any
@jlprop Null     => Nothing
@jlprop ColumnData => DataDict
@jlprop JSON => Bokeh.Model.JSONString
@jlprop Dict     => Dict{jlprop(cls, prop.keys_type).type, jlprop(cls, prop.values_type).type}
@jlprop (List, Seq, Array) => Vector{jlprop(cls, prop.item_type).type}
@jlprop Tuple    => Tuple{(jlprop(cls, i).type for i ∈ prop._type_params)...}
@jlprop Struct   => NamedTuple{
    tuple((pyconvert(Symbol, i) for i ∈ prop._fields.keys())...),
    Tuple{(jlprop(cls, i).type for i ∈ prop._fields.values())...},
}
@jlprop Instance => Instance{if pyhasattr(prop._instance_type, "__name__")
    pyconvert(Symbol, prop._instance_type.__name__)
else
    Symbol(split(pyconvert(String, prop._instance_type), '.')[end])
end}
@jlprop Nullable => Bokeh.Model.Nullable{jlprop(cls, prop.type_param).type}
@jlprop Readonly => Bokeh.Model.ReadOnly{jlprop(cls, prop.type_param).type}
@jlprop Enum     => Bokeh.Model.EnumType{tuple(Set([pyconvert(Symbol, j) for j ∈ prop._enum._values])...)}
@jlprop Either   => let enu = (; type = _enum((i for i ∈ prop._type_params)...))
    types = NamedTuple[(jlprop(cls, i) for i ∈ prop._type_params if !_isenum(i))...]
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
@jlprop RestrictedDict => Dict{
    Bokeh.Model.RestrictedKey{tuple((pyconvert(Symbol, i) for i ∈ prop._disallow)...)},
    jlprop(cls, prop.values_type).type
}

jlprop(::Val{:NonNullable}, cls, prop) = merge(jlprop(cls, prop.type_param), (; default = nothing))

for name ∈ names(Bokeh.Model; all = true)
    𝑃 = getfield(Bokeh.Model, name)
    ((𝑃 isa DataType) && (𝑃 <: Bokeh.Model.iProperty)) || continue
    @eval @jlprop $(name)
end

jlprop(cls, prop) = jlprop(Val(pyconvert(Symbol, prop.__class__.__name__)), cls, prop)
jlprop(c::Symbol, p::Symbol) = jlprop(jlmodel("$c"), getproperty(jlmodel("$c"), p).property)

export jlprop
end

using .JLProp
