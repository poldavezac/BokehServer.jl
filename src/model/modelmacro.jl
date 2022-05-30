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
                default  = line.head ≡ :(::) ? nothing : Some(line.args[2]),
                js       = !(realtype <: Internal),
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

function _👻structure(
        cls     :: Symbol,
        parents :: Union{Symbol, Expr},
        fields  :: Vector{<:NamedTuple},
)
    aliases = [i.name => i.parameters[1] for i ∈ fields if i.type <: Alias]

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
            $((:($(i.name)::$(bokehfieldtype(i.type))) for i ∈ fields if !(i.type <: Alias))...)
            callbacks :: Vector{Function}

            function $cls(; id = $(@__MODULE__).ID(), kwa...)
                new(
                    id isa Int64 ? id : parse(Int64, string(id)),
                    $((initcode(i) for i ∈ fields if !(i.type isa Alias))...),
                    Function[],
                )
            end
        end
    end
end

function _👻setter(cls::Symbol, fields::Vector{<:NamedTuple})
    function setter(field)
        name = Meta.quot(field.name)
        if field.js
            quote
                old = $(@__MODULE__).bokehrawtype(getproperty(μ, $name))
                new = setfield!(μ, $name, ν)
                dotrigger && Bokeh.Events.trigger(
                    $(@__MODULE__).changeevent($(field.type), μ, $name, old, new)
                )
            end
        else
            :(setfield!(µ, $name, ν))
        end
    end

    quote
        function Base.setproperty!(μ::$cls, α::Symbol, ν; dotrigger :: Bool = true)
            $(_👻elseif(fields, :(throw(ErrorException("unknown or read-only property $α")))) do i
                name = Meta.quot(i.name)
                if i.type <: Alias
                    i = only(j for j ∈ fields if j.name ≡ i.type.parameters[1])
                end
                if i.type <: Union{ReadOnly, Internal{<:ReadOnly}, iSpec{<:ReadOnly}, Container{<:ReadOnly}}
                    nothing
                else
                    :(if α ≡ $name
                        ν = $(@__MODULE__).bokehwrite($(i.type), $(@__MODULE__).bokehrawtype(ν))
                        $(setter(i))
                        return getproperty(µ, $(Meta.quot(i.name)))
                    end)
                end
            end)
        end
    end
end

function _👻getter(cls::Symbol, fields::Vector{<:NamedTuple})
    internals = (:id, :callbacks, (i.name for i ∈ fields if i.type <: Internal)...)
    expr      = _👻elseif(fields, :(throw(ErrorException("unknown property $α")))) do i
        old = Meta.quot(i.name)
        if i.type <: Alias
            i = only(j for j ∈ fields if j.name ≡ i.type.parameters[1])
        end
        new = Meta.quot(i.name)
        :(if α ≡ $old
              return $(@__MODULE__).bokehread($(i.type), μ, $new, getfield(µ, $new))
        end)
    end

    code = :(if α ∈ $internals
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
            _👻elseif((i for i ∈ fields if i.js), false) do field
                :(if attr ≡ $(Meta.quot(field.name))
                      true
                end)
            end
        end

        function $(@__MODULE__).defaultvalue(::Type{$cls}, attr::Symbol) :: Union{Some, Nothing}
            $(_👻elseif(fields, :(@error "No default value" class = $cls attr)) do field
                if isnothing(field.default) || field.type <: Alias
                    nothing
                else
                    :(if attr ≡ $(Meta.quot(field.name))
                        Some($(something(field.default)))
                    end)
                end
            end)
        end

        function bokehfields(::Type{$cls})
            return tuple($((
                :($(Meta.quot(i.name)) => i.type)
                for i ∈ sort(fields; by = string∘first)
                if !(i <: Union{Alia, Internal}) && i.js
            )...))
        end
    end
end

function _👻code(mod::Module, code::Expr)
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """Bokeh structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning"""
    end
    @assert code.args[2] isa Expr "Bokeh class must have a parent (iHasProps, iModel?)"
    @assert code.args[2].head ≡ :(<:) "Bokeh class cannot be templated"

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
    _👻code(__module__, expr)
end

function defaultvalue end
function bokehproperties end
function hasbokehproperty end

const ID = bokehidmaker()

Base.repr(mdl::T) where {T <: iHasProps} = "$T(id = $(bokehid(mdl)))" 

export @model
