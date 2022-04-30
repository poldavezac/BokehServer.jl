module Models
using ..Bokeh

abstract type iHasProps end
abstract type iModel <: iHasProps end
abstract type iDataSource <: iModel end
abstract type iSourcedModel <: iModel end

struct Column
    column :: String 

    Column(x::Union{AbstractString, Symbol}) = new(string(x))
end

macro col_str(x) Column(x) end

const MODELS = Dict{Symbol, DataType}()

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
        name :: Symbol,
        cls::Symbol,
        fields::Vector{<:NamedTuple},
        hassource :: Bool,
        hasprops :: Bool;
)
    :(mutable struct $name <: Bokeh.$(hassource ? :iSourcedModel : hasprops ? :iHasProps : :iModel)
        id        :: Int64
        values    :: $cls
        callbacks :: $(_model_cbcls(name))
        $(hassource ? :(source :: $(_model_srccls(name, hassource)[1])) : nothing)
    end)
end

function _model_funcs(bkcls::Symbol, datacls::Symbol, fields::Vector{<:NamedTuple}, hassource::Bool)
    quote
        Bokeh.Models.modeltype(::Type{$datacls}) = $bkcls
        Bokeh.Models.modeltype(::Type{$bkcls}) = $datacls
        @inline function Bokeh.Models.bokehproperties(::Type{$bkcls}; select::Symbol = :all)
            if select ≡ :children
                tuple($(((Meta.quot(i.name) for i ∈ fields if i.js && i.children)...)))
            elseif select ≡ :child
                tuple($(((Meta.quot(i.name) for i ∈ fields if i.js && i.child)...)))
            else
                tuple($(((Meta.quot(i.name) for i ∈ fields if i.js)...)))
            end
        end
    end
end

function _model_code(mod::Module, code::Expr, hassource :: Bool, hasprops::Bool, opts::Vector{Regex})
    @assert code.head ≡ :struct
    fields = _model_fields(mod, code, opts)

    # remove default part from the field lines
    for field ∈ fields
        if !isnothing(field.default)
            code.args[end].args[field.index] = code.args[end].args[field.index].args[1]
        end
    end

    if code.args[2] isa Expr
        bkcls   = code.args[2].args[1]
        datacls = code.args[2].args[1] = Symbol("Data$bkcls")
    else
        bkcls   = code.args[2]
        datacls = code.args[2] = Symbol("Data$bkcls")
    end
    
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
        @Base.__doc__ $(_model_bkcls(bkcls, datacls, fields, hassource, hasprops))

        $bkcls($(Expr(
                :parameters,
                let expr = :(id :: Int64 = Bokeh.Models.newmodelid())
                    Expr(:kw, expr.args...)
                end,
                params.args...
        ))) = $bkcls(
            id,
            $datacls($((i.name for i ∈ fields)...)),
            $(_model_cbcls(bkcls))(),
            $((:($i()) for i ∈ _model_srccls(bkcls, hassource))...)
        )

        $(_model_funcs(bkcls, datacls, fields, hassource))
    end)
end

function _model_code(mod::Module, cls::Symbol, hassource :: Bool, hasprops::Bool, opts::Vararg{Regex})
    fields = _model_fields(mod, code, opts...)
    bkcls  = Symbol("Bokeh$cls")
    quote
        @Base.__doc__ $code

        $(_model_srccls(cls, fields, hassource))
        $(_model_cbcls(cls, fields))
        @Base.__doc__ $(_model_bkcls(bkcls, cls, fields, hassource))

        $bkcls(args...; id :: Int64 = Bokeh.Models.newmodelid(), kwa...) = $bkcls(
            id,
            $cls(args...; kwa...),
            $(_model_cbcls(cls))(),
            $((:($i()) for i ∈ _model_srccls(cls, hassource))...)
        )

        $(_model_funcs(bkcls, cls, fields, hassource))
    end
end

macro model(args::Vararg{Union{Expr, String, Symbol}})
    expr = [x for x ∈ args if x isa Expr && x.head ≡ :struct]
    if isempty(expr)
        expr = [x for x ∈ expr if x isa Symbol && x ∉ (:source,)]
    end
    getkw(key) = [i.args[2] for i ∈ args if i isa Expr && i.head ≡ :(=)  && i.args[1] ≡ key]
    internal   = append!(
        Regex[],
        (
            Regex.(string.(i isa Union{String, Symbol} ? [i] : i.args))
            for i ∈ getkw(:internal)
        )...
    )
    @assert length(expr) ≡ 1 "Unrecognized expression: missing struct"
    code = _model_code(
        __module__,
        expr[1],
        :source ∈ args || any(getkw(:source)),
        any(getkw(:parent) .≡ :iHasProps),
        internal
    )
end

for (tpe, others) ∈ (iHasProps => (), iSourcedModel => (:data_source,)) 
    @eval function Base.propertynames(μ::$tpe; private::Bool = false)
        return if private
            (propertynames(getfield(μ, :values))..., fieldnames(μ)..., $(Meta.quot.(others)...), :id)
        else
            (propertynames(getfield(μ, :values))..., $(Meta.quot.(others)...))
        end
    end
end

function modeltype end
function bokehproperties end

function Base.getproperty(μ::T, α::Symbol) where {T <: iHasProps}
    if α ∈ fieldnames(T)
        return getfield(μ, α)
    elseif α ≡ :data_source
        return getfield(μ, :sourced).source
    elseif α ∈ bokehproperties(T)
        src = getfield(getfield(μ, :sourced), α)
        isnothing(src) || return src
    end
    return getfield(getfield(μ, :values), α)
end

function Base.setproperty!(
        μ         :: T,
        α         :: Symbol,
        υ         :: Any;
        dotrigger :: Bool = true,
        force     :: Bool = false
) where {T <: iHasProps}
    return if α ∈ fieldnames(T)
        setfield!(μ, α, υ)
    elseif α ≡ :data_source
        setfield!(getfield(μ, :sourced), :source, υ)
    elseif α ∈ bokehproperties(T)
        check_hasdoc()

        old = getproperty(μ, α)
        new = if μ isa Column
            setfield!(getfield(μ, :sourced), α, υ.column)
        else
            setfield!(getfield(μ, :sourced), α, nothing)
            setfield!(getfield(μ, :υs), α, υ)
        end
        dotrigger && trigger(μ, α, old, new; force)
    else
        setfield!(getfield(μ, :υs), α, υ)
    end
end

modelid(μ::iModel) = getfield(μ, :id)

function allmodels(μ::Vararg{iModel}) :: Dict{Int64, iModel}
    found = Dict{Int64, iModel}(modelid(i) => i for i ∈ μ)
    todos = collect(iModel, μ)
    while !isempty(todos)
        cur = pop!(todos)
        key = modelid(cur)
        (cur ∈ found) && continue
        found[modelid(cur)] = cur
        for child in childmodels(cur)
            if modelid(child) ∉ keys(found)
                push!(todos, child) 
            end
        end

    end
    found
end

function childmodels(μ::T) where {T <: iModel}
    return Iterators.flatten((childmodels(attr) for field ∈ bokehproperties(T))...)
end

childmodels(::Union{AbstractString, Symbol, Number}) = ()
childmodels(mdl::iModel) = (mdl,)
childmodels(mdl::Union{Set{<:iModel}, AbstractArray{<:iModel}}) = mdl
childmodels(mdl::Union{AbstractSet, AbstractArray}) = (i for i ∈ mdl if i isa iModel)
childmodels(mdl::Dict) = (i for j ∈ mdl for i ∈ j if i isa iModel)

const _MODELIDS = Int64[1000 for _ ∈ 1:Threads.nthreads()]

newmodelid() = (_MODELIDS[Threads.threadid()] += 1)

export iModel, iDataSource, iHasProps, iSourcedModel, @model, Column, @col_str, allmodels, childmodels
end

using .Models
iDataSource
