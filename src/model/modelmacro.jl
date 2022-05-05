"""
    macro model(args::Vararg{Union{Expr, String, Symbol}})

Allows creating Bokeh-aware model.

Classes are created and aggregated into the final class `XXX`:

* `DataXXX`: a class as provided in the macro arguments. It stores the fields
with the exact types provided in the macro.
* `CbXXX`: a class with the same fields as `DataXXX` but with types
`Vector{Function}`, used for callbacks.
* Optionally `SrcXXX`: a class with the same fields as `XXX` but with types
`Symbol`, used for overloading the `XXX` fields with a data source column.

The final class has properties to simulate the behavior of a *normal* struct.
These properties also inform the current event list of any change.

** Note ** The same behaviour as when using `Base.@kwdef` is provided. It's good
practice to always provide default values. If not

** Note ** Internal fields, not passed to `bokehjs` can be specified using
`internal = ["a regex", "another regex"]`. Any field matching one of the
regular expressions is *internal*. Internal fields are not added to the `CbXXX`
or `SrcXXX` classes.

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
const _MODELS = Set{DataType}()

function _model_fields(mod, code, opts::Vector{Regex} = Regex[])
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
                index, name, type,
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

_model_srccls(cls::Symbol, hassource :: Bool) =  hassource ? (Symbol("Src$cls"),) : ()

function _model_srccls(cls::Symbol, fields::Vector{<:NamedTuple}, hassource :: Bool)
    if hassource
        src = Symbol("Src$cls")
        :(@Base.kwdef mutable struct $src
            source :: Union{Bokeh.iDataSource, Nothing} = nothing
            $((
                :($(i.name) :: Union{Symbol, Nothing} = nothing)
                for i ∈ fields if i.js
            )...)
        end)
    else
        nothing
    end
end

_model_cbcls(cls::Symbol)  = Symbol("Cb$cls")

function _model_cbcls(cls::Symbol, fields::Vector{<:NamedTuple})
    cbcls = _model_cbcls(cls)
    return :(struct $cbcls
        $((:($(i.name) :: Vector{Function}) for i ∈ fields if i.js)...)
        $cbcls() = new((Function[] for _ ∈ 1:$(sum(1 for i ∈ fields if i.js)))...)
    end)
end

function _model_bkcls(
        name      :: Symbol,
        cls       :: Symbol,
        parents   :: Union{Symbol, Expr},
        fields    :: Vector{<:NamedTuple},
        hassource :: Bool
)
    quote
        mutable struct $name <: $parents
            id        :: Int64
            original  :: $cls
            callbacks :: $(_model_cbcls(name))
            $(hassource ? :(source :: $(_model_srccls(name, hassource)[1])) : nothing)
        end

        push!(_MODELS, $name)
    end
end

function _model_funcs(bkcls::Symbol, datacls::Symbol, fields::Vector{<:NamedTuple}, hassource::Bool)
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

    function elseifblock(func::Function, itr, elsecode = :(@assert false "unknown condition"))
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

    quote
        Bokeh.Models.modeltype(::Type{$datacls}) = $bkcls
        Bokeh.Models.modeltype(::Type{$bkcls}) = $datacls
        @inline function Bokeh.Models.bokehproperties(::Type{$bkcls}; select::Symbol = :all, sorted::Bool = false)
            $(elseifblock(Iterators.product((false, true), (:all, :children, :child))) do (sort, select)
                :(if sorted ≡ $sort && select ≡ $(Meta.quot(select))
                    tuple($(items(select, sort)...))
                end)
            end)
        end

        function Bokeh.Models.defaultvalue(::Type{$bkcls}, attr::Symbol) :: Union{Some, Nothing}
            $(elseifblock(fields, :(@error "No default value" class = $bkcls attr)) do field
                if isnothing(field.default)
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

function _model_code(mod::Module, code::Expr, opts::Vector{Regex})
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """Bokeh structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning"""
    end
    @assert code.args[2] isa Expr "Bokeh class must have a parent (iHasProps, iModel, iSourcedModel?)"
    @assert code.args[2].head ≡ :(<:) "Bokeh class cannot be templated"

    code.args[1] = true
    fields = _model_fields(mod, code, opts)

    # remove default part from the field lines
    for field ∈ fields
        if !isnothing(field.default)
            code.args[end].args[field.index] = code.args[end].args[field.index].args[1]
        end
    end

    parents   = code.args[2].args[2]
    bkcls     = code.args[2].args[1]
    datacls   = code.args[2] = Symbol("Data$bkcls")
    hassource = mod.eval(parents) <: iSourcedModel

    params = Expr(
        :parameters,
        (
            isnothing(i.default) ? Expr(:kw, i.name) : Expr(:kw, i.name, something(i.default))
            for i ∈ fields
        )...
    )

    esc(quote
        @Base.__doc__ $code

        $datacls($params) = $datacls($((i.name for i ∈ fields)...))

        $(_model_srccls(bkcls, fields, hassource))
        $(_model_cbcls(bkcls, fields))
        @Base.__doc__ $(_model_bkcls(bkcls, datacls, parents, fields, hassource))

        function $bkcls(; id :: Int64 = Bokeh.Models.ID(), kwa...)
            obj = $bkcls(
                id,

                # hijack the object construction to apply theme defaults
                Bokeh.Themes.theme($datacls),

                # the callback instance
                $(_model_cbcls(bkcls))(),

                # the optional data source instance
                $((:($i()) for i ∈ _model_srccls(bkcls, hassource))...)
            )
            for (attr, val) ∈ kwa
                setproperty!(obj, attr, val; dotrigger = false)
            end
            obj
        end

        $(_model_funcs(bkcls, datacls, fields, hassource))
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
    _model_code(__module__, expr[1], internal)
end

function modeltype end
function defaultvalue end
function modelsource end
function bokehproperties end

const ID = BokehIdMaker()

export @model
