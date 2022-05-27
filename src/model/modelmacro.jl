"""
    macro model(args::Vararg{Union{Expr, String, Symbol}})

Allows creating Bokeh-aware model.

Classes are created and aggregated into the final class `XXX`:

* `DataXXX`: a class as provided in the macro arguments. It stores the fields
with the exact types provided in the macro.
* Optionally `SrcXXX`: a class with the same fields as `XXX` but with types
`Symbol`, used for overloading the `XXX` fields with a data source column.

The final class has properties to simulate the behavior of a *normal* struct.
These properties also inform the current event list of any change.

** Note ** The same behaviour as when using `Base.@kwdef` is provided. It's good
practice to always provide default values. If not

** Note ** Internal fields, not passed to `bokehjs` can be specified using
`internal = ["a regex", "another regex"]`. Any field matching one of the
regular expressions is *internal*. Internal fields are not added to the 
`SrcXXX` class.

## Examples

```julia
"X is a structure with a `data_source` property"
@Bokeh.model struct X <: Bokeh.iSourcedModel
    field1::Int     = 0
    field2::Float64 = 0.0
end
@assert propertynames(X) ≡ (:field1, :field2, :data_source)
@assert X().field1 ≡ 0
@assert X().field2 ≡ 0.0

"Y is a structure *without* a `data_source` property"
@Bokeh.model struct Y <: Bokeh.iModel
    field1::Int     = 0
    field2::Float64 = 0.0
end
@assert propertynames(Y) ≡ (:field1, :field2)
@assert Y().field1 ≡ 0
@assert Y().field2 ≡ 0.0
```

"Z is a structure where fields `nojs1` and `nojs2` are *not* passed to bokehjs"
@Bokeh.model internal = ["nojs.*"] struct Z <: Bokeh.iModel
    nojs1 :: Any  = []
    nojs2 :: Any  = Set([])
    field1::Int     = 0
    field2::Float64 = 0.0
end
"""
:(@model)

"Stores every class created by the @model macro"
const MODEL_TYPES = Set{DataType}()

function _𝑚elseif(func::Function, itr, elsecode = :(@assert false "unknown condition"))
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

function _𝑚fields(mod, code, opts::Vector{Regex} = Regex[])
    isjs = if isempty(opts)
        # all fields are bokeh fields
        (_)->true
    else
        # select fields mentioned in `args` as bokeh fields
        (x)-> let val = "$x"
            all(isnothing(match(r, val)) for r ∈ opts)
        end
    end

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

            realtype = mod.eval(type)
            (;
                index, name,
                type     = realtype,
                default  = line.head ≡ :(::) ? nothing : Some(line.args[2]),
                js       = isjs(name),
                child    = realtype <: iModel,
                children = let els = eltype(realtype)
                    # Pair comes out for Dict, for example
                    any(i <: iModel for i ∈ (els <: Pair ? els.parameters : (els,)))
                end
            )
        end
        for (index, line) ∈ enumerate(code.args[end].args)
        if isfield(line)
    ]
end

function _𝑚bkcls(
        name      :: Symbol,
        cls       :: Symbol,
        parents   :: Union{Symbol, Expr},
        fields    :: Vector{<:NamedTuple},
)
    aliases = [i.name => i.parameters[1] for i ∈ fields if i.type <: Alias]

    function initcode(field)
        opts = [first(j) for j ∈ aliases if last(j) ≡ field.name]
        val  = quote
            val = Bokeh.Themes.theme($bkcls, α)
            $(if isnothing(field.default)
                nothing
            else
                :(isnothing(val) && (val = Bokeh.Models.defaultvalue($bkcls, α)))
            end)
            if isnothing(val)
                throw(ErrorException(($("$bkcls.$(i.name) is a mandatory argument"))))
            else
                some(val)
            end
        end
            
        val  = _𝑚elseif((field.name, opts...), val) do key
            :(if haskey(kwa, $(Meta.quot(key)))
                kwa[$(Meta.quot(key))]
            end)
        end
        :(Bokeh.Models.bokehconvert($(i.type), $val))
    end

    quote
        mutable struct $name <: $parents
            id        :: Int64
            $((:($(i.name)::$(bokehfieldtype(i.type))) for i ∈ fields if !(i.type <: Alias))...)
            callbacks :: Vector{Function}

            function $bkcls(; id = Bokeh.Models.ID(), kwa...)
                new(
                    id isa Int64 ? id : parse(Int64, string(id)),
                    $((initcode(i) for i ∈ fields if !(i.type isa Alias))...)
                    Function[],
                )
            end
        end

        push!(Bokeh.Models.MODEL_TYPES, $name)
    end
end

function _𝑚setter(bkcls::Symbol, fields::Vector{<:NamedTuple})
    function setter(field)
        if field.js
            quote
                old = bokehrawtype(getproperty(μ, α))
                new = setfield!(μ, α, υ)
                dotrigger && Bokeh.Events.trigger(
                    Bokeh.Models.changeevent($(field.type), μ, α, old, new)
                )
                new
            end
        else
            :(setfield!(µ, $(Meta.quot(field.name)), α))
        end
    end

    quote
        function Base.setproperty!(μ::$bkcs, α::Symbol, ν; dotrigger :: Bool = true)
            $(_𝑚elseif(fields, :(throw(ErrorException("unknown property $α")))) do i
                name = Meta.quot(i.name)
                if i.type <: Alias
                    i = only(j for j ∈ fields if j.name ≡ i.type.parameters[1])
                end

                :(if α ≡ $name
                    ν = bokehwrite($(i.type), μ, $(Meta.quot(i.name)), bokehrawtype(ν))
                    return $(setter(i))
                end)
            end)
        end
    end
end

function _𝑚getter(bkcls::Symbol, fields::Vector{<:NamedTuple})
    quote
        function Base.getproperty(μ::$bkcs, α::Symbol)
            $(_𝑚elseif(fields, :(throw(ErrorException("unknown property $α")))) do i
                old = Meta.quot(i.name)
                if i.type <: Alias
                    i = only(j for j ∈ fields if j.name ≡ i.type.parameters[1])
                end
                new = Meta.quot(i.name)
                :(if α ≡ $old
                    return bokehread($(i.type), μ, $new, getfield(µ, $new))
                end)
            end)
        end
    end
end

function _𝑚propnames(bkcls::Symbol, fields::Vector{<:NamedTuple})
    quote
        function Base.propertynames(μ::$bkcls; private::Bool = false)
            return if private
                fieldnames(µ)
            else
                $(tuple((i.name for i ∈ fields)..., :id, :callbacks))
            end
        end
    end
end

function _𝑚funcs(bkcls::Symbol, fields::Vector{<:NamedTuple})
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
        @inline function Bokeh.Models.bokehproperties(::Type{$bkcls}; select::Symbol = :all, sorted::Bool = false)
            $(_𝑚elseif(Iterators.product((false, true), (:all, :children, :child))) do (sort, select)
                :(if sorted ≡ $sort && select ≡ $(Meta.quot(select))
                    tuple($(items(select, sort)...))
                end)
            end)
        end

        @inline function Bokeh.Models.hasbokehproperty(T::Type{$bkcls}, attr::Symbol)
            return $(if all(i.js && for i in fields)
                :(hasfield(fieldtype(T, :original), attr))
            else
                _𝑚elseif((i for i ∈ fields if i.js), false) do field
                    :(if attr ≡ $(Meta.quot(field.name))
                          true
                    end)
                end
            end)
        end

        function Bokeh.Models.defaultvalue(::Type{$bkcls}, attr::Symbol) :: Union{Some, Nothing}
            $(_𝑚elseif(fields, :(@error "No default value" class = $bkcls attr)) do field
                if isnothing(field.default) || i.type <: Alias
                    nothing
                else
                    :(if attr ≡ $(Meta.quot(field.name))
                        Some($(something(field.default)))
                    end)
                end
            end)
        end
    end
end

function _𝑚code(mod::Module, code::Expr, opts::Vector{Regex})
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """Bokeh structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning"""
    end
    @assert code.args[2] isa Expr "Bokeh class must have a parent (iHasProps, iModel, iSourcedModel?)"
    @assert code.args[2].head ≡ :(<:) "Bokeh class cannot be templated"

    code.args[1] = true
    fields = _𝑚fields(mod, code, opts)

    # remove default part from the field lines
    for field ∈ fields
        if !isnothing(field.default)
            code.args[end].args[field.index] = code.args[end].args[field.index].args[1]
        end
    end

    parents = code.args[2].args[2]
    bkcls   = code.args[2].args[1]
    esc(quote
        @Base.__doc__ $(_𝑚bkcls(bkcls, parents, fields))

        $(_𝑚getter(bkcls, fields))
        $(_𝑚setter(bkcls, fields))
        $(_𝑚propnames(bkcls, fields))
        $(_𝑚funcs(bkcls, fields))
    end)
end

macro model(args::Vararg{Union{Expr, String, Symbol}})
    expr = [x for x ∈ args if x isa Expr && x.head ≡ :struct]
    if isempty(expr)
        expr = [x for x ∈ expr if x isa Symbol && x ∉ (:source,)]
    end
    @assert length(expr) ≡ 1 "Unrecognized expression: missing struct"

    getkw(key) = [i.args[2] for i ∈ args if i isa Expr && i.head ≡ :(=)  && i.args[1] ≡ key]

    internal   = append!(
        Regex[],
        (
            Regex.(string.(i isa Union{String, Symbol} ? [i] : i.args))
            for i ∈ getkw(:internal)
        )...
    )
    _𝑚code(__module__, expr[1], internal)
end

function defaultvalue end
function bokehproperties end
function hasbokehproperty end

const ID = bokehidmaker()

Base.repr(mdl::T) where {T <: iHasProps} = "$T(id = $(bokehid(mdl)))" 

export @model
