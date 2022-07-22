module Properties
using ..BokehServer
using ..BokehServer.Model.Dates
using ..BokehServer.Themes.JSON
try
    using ..BokehServer.Models
catch
    BokehServer.eval(:(module Models end))
end
using ..BokehServer.Models
using PythonCall
using ..Defaults: parsedefault, model, modelnames
export parsedefault, model, modelnames

macro property(opt)
    others = nothing
    if opt isa Symbol
        type = opt
        name = Val{opt}
    else
        @assert opt.head ≡ :call && opt.args[1] ≡ :(=>)
        (types, type) = opt.args[2:end]
        name = types isa Expr ? Union{(Val{i} for i ∈ types.args)...} : Val{types}
    end
    (type isa Symbol) && (type = getfield(BokehServer.Model, type))
    :(function parseproperty(::$name, cls, attr::Symbol, prop)
        type    = $type
        doc     = pyis(prop.__doc__, @py(None)) ? nothing : pyconvert(String, prop.__doc__)
        default = parsedefault(type, cls, attr, prop)
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
    BokehServer.Model.EnumType{tuple(vals...)}
end

function parseproperty(::Val{T}, cls, attr::Symbol, prop) where {T}
    type    = if T ∈ names(BokehServer.Model; all = true)
        getfield(BokehServer.Model, T)
    elseif endswith("$T", "Spec")
        BokehServer.Model.Spec{getfield(BokehServer.Model, Symbol("$T"[1:end-4]))}
    else
        throw(ErrorException("Cannot deal with python property `$T`"))
    end

    doc     = pyis(prop.__doc__, @py(None)) ? nothing : pyconvert(String, prop.__doc__)
    default = parsedefault(type, cls, attr, prop)
    ismissing(default) && throw(ErrorException("unknown default $cls.$prop = $(prop._default)"))
    return (; type, default, doc)
end

@property Date      => Date
@property Datetime  => DateTime
@property TimeDelta => Period
@property Bool
@property Regex
@property Int
@property String
@property MathString => String
@property Any
@property Float    => Float64
@property AnyRef   => Any
@property Null     => Nothing
@property ColumnData => DataDict
@property Interval => BokehServer.Model.Interval{pyconvert(Float64, prop.start), pyconvert(Float64, prop.end)}
@property JSON => BokehServer.Model.JSONString
@property Dict     => Dict{parseproperty(cls, prop.keys_type).type, parseproperty(cls, prop.values_type).type}
@property (List, Seq, Array) => Vector{parseproperty(cls, prop.item_type).type}
@property Tuple    => Tuple{(parseproperty(cls, i).type for i ∈ prop._type_params)...}
@property Struct   => NamedTuple{
    tuple((pyconvert(Symbol, i) for i ∈ prop._fields.keys())...),
    Tuple{(parseproperty(cls, i).type for i ∈ prop._fields.values())...},
}
@property Instance => let cls  = if pyhasattr(prop._instance_type, "__name__")
        pyconvert(Symbol, prop._instance_type.__name__)
    else
        Symbol(split(pyconvert(String, prop._instance_type), '.')[end])
    end

    if cls ∉ names(BokehServer.Models; all = true)
        BokehServer.Models.eval(:(struct $cls end))
    end
    getfield(BokehServer.Models, cls)
end
@property Nullable => Union{Nothing, parseproperty(cls, prop.type_param).type}
@property Readonly => BokehServer.Model.ReadOnly{parseproperty(cls, prop.type_param).type}
@property Enum     => let vals = tuple(unique!([pyconvert(Symbol, j) for j ∈ prop._enum._values])...)
    BokehServer.Model.EnumType{vals}
end
@property Either   => let enu = (; type = _enum((i for i ∈ prop._type_params)...))
    types = NamedTuple[(parseproperty(cls, i) for i ∈ prop._type_params if !_isenum(i))...]
    if isempty(types)
        @assert !isempty(values(enu.type))
        enu.type
    else
        isempty(values(enu.type)) || insert!(types, 1, enu)

        hasnull = any(isnothing(i) for i ∈ types)
        hasnull && filter!(!isnothing, type)
        out = length(types) == 1 ? types[1].type : Union{(i.type for i ∈ types)...}
        hasnull ? Union{Nothing, out} : out
    end
end
@property RestrictedDict => Dict{
    BokehServer.Model.RestrictedKey{tuple((pyconvert(Symbol, i) for i ∈ prop._disallow)...)},
    parseproperty(cls, prop.values_type).type
}

parseproperty(::Val{:NonNullable}, cls, _::Symbol, prop) = merge(parseproperty(cls, prop.type_param), (; default = nothing))
parseproperty(::Val{:Alias}, _, __::Symbol, prop) = (;
    type = BokehServer.Model.Alias{pyconvert(Symbol, prop.aliased_name)}, default = nothing, doc = nothing
)

for name ∈ names(BokehServer.Model; all = true)
    𝑃 = getfield(BokehServer.Model, name)
    ((𝑃 isa DataType) && (𝑃 <: BokehServer.Model.iProperty)) || continue
    @eval @property $(name)
end

propertytype(prop) = Val(pyconvert(Symbol, prop.__class__.__name__))
function parseproperty(cls::Py, attr::Symbol)
    prop = getproperty(cls, attr).property
    parseproperty(propertytype(prop), cls, attr, prop)
end
parseproperty(cls::Py, prop::Py) = parseproperty(propertytype(prop), cls, :_, prop)
parseproperty(c::Symbol, p)      = parseproperty(model("$c"), p)


const _END_PATT = r"^end" => "finish"
const _MODEL_FIELDS = (:js_event_callbacks, :js_property_callbacks, :name, :subscribed_events, :syncable, :tags)
_fieldname(x) = Symbol(replace(pyconvert(String, x), _END_PATT))

parseproperties(name) = parseproperties(Val(Symbol(name)), model(name))
parseproperties(x::Val, cls::Py; allprops::Bool = false) = parseproperties(cls; allprops)

function parseproperties(::Val{:GlyphRenderer}, cls::Py; k...)
    out = parseproperties(cls; k...)
    out[:view] = merge(out[:view], (; default = Some(:(new(CDSView(; source = data_source))))))
    return out
end

function parseproperties(::Union{(Val{i} for i ∈ (:DataCube, :DataTable))...}, cls::Py; k...)
    out = parseproperties(cls; k...)
    out[:view] = merge(out[:view], (; default = Some(:(new(CDSView(; source))))))
    return out
end

function parseproperties(::Val{:BoxAnnotation}, cls::Py; k...)
    out = parseproperties(cls; k...)
    for i ∈ (:left, :right, :top, :bottom)
        out[i] = merge(out[i], (; type = Union{Nothing, Float64}, default = Some(nothing)))
    end
    return out
end

function parseproperties(cls::Py; allprops::Bool = false)
    attrs = Dict{Symbol, Any}(
        _fieldname(attr) => try
            parseproperty(cls, pyconvert(Symbol, attr))
        catch exc
            @error(
                "Could not deal with $cls.$attr => $(getproperty(cls, pyconvert(String, attr)).property)",
                exception = (exc, Base.catch_backtrace())
            )

            rethrow()
        end
        for attr ∈ cls.properties()
        if allprops || _fieldname(attr) ∉ _MODEL_FIELDS
    )
    attrs[:__doc__] = let x = cls.__doc__
        pyis(x, nothing) ? nothing : pyconvert(String, x)
    end
    attrs
end

parseproperties() = Dict(i => parseproperties(i) for i ∈ modelnames())
export parseproperty, parseproperties, _fieldname
end

using .Properties
