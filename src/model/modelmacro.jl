"""
    macro model(args::Vararg{Union{Expr, String, Symbol}})

Allows creating Bokeh-aware model:

* the model can be transfered to the javascript client
* changes to the fields will trigger events which one can subscribe to
 
** Note ** Dicts and Vectors are wrapped in a `Container` class
which allows triggering an event when using `push!` methods and
others of the same type.

** Note ** The same behaviour as when using `Base.@kwdef` is provided. It's good
practice to always provide default values.

** Note ** Wrapping a type in `Internal` will remove the field 
from the Bokeh behavior: the client remains unaware of it and
changes trigger no event.

## Examples

```julia
@Bokeh.model mutable struct X <: Bokeh.iModel
    field1::Int     = 0
    field2::Float64 = 0.0
end
@assert propertynames(X) ≡ (:field1, :field2)
@assert propertynames(X; private = true) ≡ (:field1, :field2, :id, :callbacks)
@assert X().field1 ≡ 0
@assert X().field2 ≡ 0.0

"Z is a structure where fields `nojs1` and `nojs2` are *not* passed to bokehjs"
@Bokeh.model mutable struct Z <: Bokeh.iModel
    nojs1 ::Internal{Any} = []
    nojs2 ::Internal{Any} = Set([])
    field1::Int           = 0
    field2::Float64       = 0.0
end
@assert Z().nojs1 isa Vector{Any}
@assert Z().nojs2 isa Set{Any}
"""
:(@model)

"Stores every class created by the @model macro"
const MODEL_TYPES = Set{DataType}()

function _👻elseif(func::Function, itr, elsecode = :(@assert false "unknown condition"))
    last = expr = Expr(:if)
    for args ∈ itr
        val = func(args)
        isnothing(val) && continue

        push!(last.args, val.args..., Expr(:elseif))
        last = last.args[end]
    end
    last.head = :block
    push!(last.args, elsecode)
    expr
end

function _👻fields(mod, code)
    # filter expressions :(x::X) and :(x::X = y)
    isfield(x) = if !(x isa Expr)
        false
    elseif x.head ≡ :(::)
        true
    else
        (x.args[1] isa Expr) && (x.args[1].head ≡ :(::))
    end

    # create a named tuple containing all relevant info
    # for both means of defining a struture field
    [
        begin
            (name, type) = (line.head ≡ :(::) ? line : line.args[1]).args
            realtype     = mod.eval(type)
            if realtype <: Union{AbstractDict, AbstractArray, AbstractSet}
                realtype = Container{realtype}
            end
            (;
                index, name,
                type     = realtype,
                default  = _👻defaultvalue(realtype, line),
                js       = !(realtype <: Internal),
                alias    = realtype <: Alias,
                readonly = realtype <: Union{
                    ReadOnly, Internal{<:ReadOnly}, iSpec{<:ReadOnly}, Container{<:ReadOnly}
                },
                child    = realtype <: Union{iModel, Nullable{<:iModel}},
                children = if realtype <: Container
                    els = eltype(realtype)
                    # Pair comes out for Dict, for example
                    any(i <: iModel for i ∈ (els <: Pair ? els.parameters : (els,)))
                else
                    false
                end
            )
        end
        for (index, line) ∈ enumerate(code.args[end].args)
        if isfield(line)
    ]
end

_👻filter(fields, attr = :alias)  = (i for i ∈ fields if !getfield(i, attr))

function _👻aliases(f, fields)
    return (f.name, (i.name for i ∈ fields if i.alias && f.name ≡ i.type.parameters[1])...)
end

function _👻elseif_alias(𝐹::Function, fields::Vector{<:NamedTuple}, elsecode)
    return _👻elseif(fields, elsecode) do cur
        if cur.alias
            nothing
        else
            code  = 𝐹(cur)
            if isnothing(code)
                nothing
            else
                names = _👻aliases(cur, fields)
                cond  = length(names) > 2 ? :(α ∈ $names) :
                    length(names) ≡ 1 ? :(α ≡ $(Meta.quot(names[1]))) :
                    :(α ≡ $(Meta.quot(names[1])) || α ≡ $(Meta.quot(names[2])))
                Expr(:if, cond, code)
            end
        end
    end
end
        

function _👻structure(
        cls     :: Symbol,
        parents :: Union{Symbol, Expr},
        fields  :: Vector{<:NamedTuple},
)
    aliases = [i.name => i.type.parameters[1] for i ∈ fields if i.alias]

    function initcode(field)
        opts = [first(j) for j ∈ aliases if last(j) ≡ field.name]
        κ    = Meta.quot(field.name)
        val  = quote
            val = Bokeh.Themes.theme($cls, $κ)
            $(isnothing(field.default) ? nothing : :(isnothing(val) && (val = $(something(field.default)))))

            isnothing(val) && throw(ErrorException(($("$cls.$(field.name) is a mandatory argument"))))
            something(val)
        end
            
        val = _👻elseif((field.name, opts...), val) do key
            κ = Meta.quot(key)
            :(if haskey(kwa, $κ)
                kwa[$κ]
            end)
        end

        return if field.type <: Internal
            val
        elseif field.type <: ReadOnly
            :($(@__MODULE__).bokehwrite($(field.type.parameters[1]), $val))
        else
            :($(@__MODULE__).bokehwrite($(field.type), $val))
        end
    end

    quote
        mutable struct $cls <: $parents
            id        :: Int64
            $((:($(i.name)::$(bokehfieldtype(i.type))) for i ∈ _👻filter(fields))...)
            callbacks :: Vector{Function}

            function $cls(; id = $(@__MODULE__).ID(), kwa...)
                new(
                    id isa Int64 ? id : parse(Int64, string(id)),
                    $(Iterators.map(initcode, _👻filter(fields))...),
                    Function[],
                )
            end
        end
    end
end

function _👻setter(cls::Symbol, fields::Vector{<:NamedTuple})
    code = _👻elseif_alias(fields, :(throw(ErrorException("unknown or read-only property $α")))) do i
        if i.readonly
            nothing
        else
            name = Meta.quot(i.name)
            set  = if i.js
                quote
                    old = $(@__MODULE__).bokehrawtype(getproperty(μ, $name))
                    new = setfield!(μ, $name, ν)
                    dotrigger && Bokeh.Events.trigger(Bokeh.ModelChangedEvent(μ, $name, old, new))
                end
            else
                :(setfield!(µ, $name, ν))
            end
            quote
                ν = $(@__MODULE__).bokehwrite($(i.type), $(@__MODULE__).bokehrawtype(ν))
                $set
                getproperty(µ, $name)
            end
        end
    end

    quote
        function Base.setproperty!(μ::$cls, α::Symbol, ν; dotrigger :: Bool = true)
            $code
        end
    end
end

function _👻getter(cls::Symbol, fields::Vector{<:NamedTuple})
    expr = _👻elseif_alias(fields, :(throw(ErrorException("unknown property $α")))) do field
        name = Meta.quot(field.name)
        :($(@__MODULE__).bokehread($(field.type), μ, $name, getfield(µ, $name)))
    end

    code = :(if α ∈ $((:id, :callbacks, (i.name for i ∈ fields if !i.js)...))
        return getfield(µ, α)
    end)
    push!(code.args, Expr(:elseif, expr.args...))

    quote
        function Base.getproperty(μ::$cls, α::Symbol)
            $code
        end
    end
end

function _👻propnames(cls::Symbol, fields::Vector{<:NamedTuple})
    quote
        function Base.propertynames(μ::$cls; private::Bool = false)
            return if private
                $(tuple(:id, (i.name for i ∈ fields)..., :callbacks))
            else
                $(tuple((i.name for i ∈ fields)...))
            end
        end
    end
end

function _👻funcs(cls::Symbol, fields::Vector{<:NamedTuple})
    function items(select::Symbol, sort::Bool)
        vals = if select ≡ :children
            [i.name for i ∈ fields if i.js && i.children]
        elseif select ≡ :child
            [i.name for i ∈ fields if i.js && i.child]
        else
            [i.name for i ∈ fields if i.js]
        end
        sort && sort!(vals)
        return Meta.quot.(vals)
    end

    quote
        @inline function $(@__MODULE__).bokehproperties(::Type{$cls}; select::Symbol = :all, sorted::Bool = false)
            $(_👻elseif(Iterators.product((false, true), (:all, :children, :child))) do (sort, select)
                :(if sorted ≡ $sort && select ≡ $(Meta.quot(select))
                    tuple($(items(select, sort)...))
                end)
            end)
        end

        @inline function $(@__MODULE__).hasbokehproperty(T::Type{$cls}, attr::Symbol)
            $(_👻elseif((i for i ∈ fields if i.js), false) do field
                :(if attr ≡ $(Meta.quot(field.name))
                    true
                end)
            end)
        end

        @inline function $(@__MODULE__).bokehpropertytype(T::Type{$cls}, α::Symbol)
            $(_👻elseif_alias(fields, :(throw("$T.$attr does not exist"))) do field
                field.js ? field.type : nothing
            end)
        end

        function $(@__MODULE__).defaultvalue(::Type{$cls}, α::Symbol) :: Union{Some, Nothing}
            $(_👻elseif_alias(fields, nothing) do field
                isnothing(field.default) ? nothing : :(Some($(something(field.default))))
            end)
        end

        function $(@__MODULE__).bokehfields(::Type{$cls})
            return tuple($((
                Expr(:call, :(=>), Meta.quot(i.name), i.type)
                for i ∈ sort(fields; by = string∘first)
                if i.js && !i.alias
            )...))
        end
    end
end

function _👻code(src, mod::Module, code::Expr)
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """Bokeh structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning""" _module = mod _file = string(src.file) _line = src.line
    end
    @assert code.args[2] isa Expr "$(code.args[2]): Bokeh structure must have a parent (iHasProps, iModel?)"
    @assert code.args[2].head ≡ :(<:) "$(code.args[2]): Bokeh structure cannot be templated"

    code.args[1] = true
    fields  = _👻fields(mod, code)
    parents = code.args[2].args[2]
    cls     = code.args[2].args[1]
    if cls isa Expr
        cls = mod.eval(cls.head ≡ :($) ? cls.args[1] : cls) 
    end
    esc(quote
        @Base.__doc__ $(_👻structure(cls, parents, fields))

        $(_👻getter(cls, fields))
        $(_👻setter(cls, fields))
        $(_👻propnames(cls, fields))
        $(_👻funcs(cls, fields))
        push!($(@__MODULE__).MODEL_TYPES, $cls)
        $cls
    end)
end

macro model(expr::Expr)
    _👻code(__source__, __module__, expr)
end

function bokehproperties end
function hasbokehproperty end
function bokehpropertytype end
function bokehfields end
function defaultvalue end

function _👻defaultvalue(T::Type, line::Expr)
    return if line.head ≡ :(::)
        _👻defaultvalue(T)
    elseif line.args[2] ≡ :nodefaults
        nothing
    elseif line.args[2] ≡ :zero
        out = _👻defaultvalue(T)
        if isnothing(out)
            R = bokehfieldtype(T)
            throw(ErrorException("Unknown defaults for $R (calls `zero($R)` or `$R()` are unavailable)"))
        end
        out
    else
        Some(line.args[2])
    end
end

function _👻defaultvalue(T::Type)
    R = bokehfieldtype(T)
    applicable(zero, R) ? Some(:(zero($R))) : applicable(R) ? Some(:($R())) : nothing
end

const ID = bokehidmaker()

Base.repr(mdl::T) where {T <: iHasProps} = "$T(id = $(bokehid(mdl)))" 

export @model
