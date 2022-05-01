module Models
using ..Bokeh: iModel

struct Column
    column :: String 

    Column(x::Union{AbstractString, Symbol}) = new(string(x))
end

macro col_str(x) Column(x) end

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
        original  :: $cls
        callbacks :: $(_model_cbcls(name))
        $(hassource ? :(source :: $(_model_srccls(name, hassource)[1])) : nothing)
    end)
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

    contents = let fold = foldr(
            Iterators.product((false, true), (:all, :children, :child));
            init = Expr(:dummy)
        ) do (expr, (select, sort))
            push!(
                exp.args,
                Expr(
                    :elseif, 
                    :(sorted ≡ $sort && select ≡ $(Meta.quot(select))),
                    :(tuple($(items(select, sort)...)))
                )
            )
        end
        # remove the :dummy expression and replace the first head by :if
        fold.args[end].head = :if
        fold.args[end]
    end

    quote
        Bokeh.Models.modeltype(::Type{$datacls}) = $bkcls
        Bokeh.Models.modeltype(::Type{$bkcls}) = $datacls
        @inline function Bokeh.Models.bokehproperties(::Type{$bkcls}; select::Symbol = :all, sorted::Bool = false)
            $contents
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
                let expr = :(id :: Int64 = Bokeh.Models.newbokehid())
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

macro model(args::Vararg{Union{Expr, String, Symbol}})
    expr = [x for x ∈ args if x isa Expr && x.head ≡ :struct]
    if isempty(expr)
        expr = [x for x ∈ expr if x isa Symbol && x ∉ (:source,)]
    end
    @assert length(expr) ≡ 1 "Unrecognized expression: missing struct"

    getkw(key) = [i.args[2] for i ∈ args if i isa Expr && i.head ≡ :(=)  && i.args[1] ≡ key]

    hasprops   = any(getkw(:parent) .≡ :iHasProps)
    hassource  = !hasprops && !any(i ≡ false for i ∈ getkw(:source))
    internal   = append!(
        Regex[],
        (
            Regex.(string.(i isa Union{String, Symbol} ? [i] : i.args))
            for i ∈ getkw(:internal)
        )...
    )
    _model_code(__module__, expr[1], hassource, hasprops, internal)
end

for (tpe, others) ∈ (iHasProps => (), iSourcedModel => (:data_source,)) 
    @eval function Base.propertynames(μ::$tpe; private::Bool = false)
        return if private
            (propertynames(getfield(μ, :original))..., fieldnames(μ)..., $(Meta.quot.(others)...), :id)
        else
            (propertynames(getfield(μ, :original))..., $(Meta.quot.(others)...))
        end
    end
end

function modeltype end
function modelsource end
function bokehproperties end

function Base.getproperty(μ::T, α::Symbol) where {T <: iHasProps}
    getfield(α ∈ fieldnames(T) ? μ : getfield(μ, :original), α)
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
    else
        old = getproperty(μ, α)
        new = setfield!(getfield(μ, :original), α, υ)
        dotrigger && (α ∈ bokehproperties(T)) && trigger(μ, α, old, new; force)
    end
end

function Base.getproperty(μ::T, α::Symbol) where {T <: iSourcedModel}
    if α ∈ fieldnames(T)
        return getfield(μ, α)
    elseif α ≡ :data_source
        return getfield(μ, :source).source
    elseif hasfield(fieldtype(T, :source), α)
        src = getfield(getfield(μ, :source), α)
        isnothing(src) || return src
    end
    return getfield(getfield(μ, :original), α)
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
        setfield!(getfield(μ, :source), :source, υ)
    elseif hasfield(fieldtype(T, :source), α)
        old = getproperty(μ, α)
        new = if μ isa Column
            setfield!(getfield(μ, :source), α, υ.column)
        else
            setfield!(getfield(μ, :source), α, nothing)
            setfield!(getfield(μ, :original), α, υ)
        end
        dotrigger && trigger(μ, α, old, new; force)
        new
    else
        setfield!(getfield(μ, :original), α, υ)
    end
end

function allmodels(μ::Vararg{iModel}) :: Dict{Int64, iModel}
    found = Dict{Int64, iModel}()
    todos = collect(iModel, μ)
    while !isempty(todos)
        cur = pop!(todos)
        key = bokehid(cur)
        (key ∈ keys(found)) && continue
        found[bokehid(cur)] = cur

        for child ∈ children(cur)
            bokehid(child) ∈ keys(found) || push!(todos, child) 
        end
    end
    found
end

function children(μ::T) where {T <: iModel}
    return Iterators.flatten(_children(getproperty(μ, field)) for field ∈ bokehproperties(T))
end

_children(::Any) = ()
_children(mdl::iModel) = (mdl,)
_children(mdl::Union{Set{<:iModel}, AbstractArray{<:iModel}}) = mdl
_children(mdl::Union{AbstractSet, AbstractArray}) = (i for i ∈ mdl if i isa iModel)
_children(mdl::Dict) = (i for j ∈ mdl for i ∈ j if i isa iModel)

const _MODELIDS = collect(1:Threads.nthreads())

newbokehid() = (_MODELIDS[Threads.threadid()] += 1000)

export iModel, iDataSource, iHasProps, iSourcedModel, @model, Column, @col_str, allmodels, children
end

using .Models
iDataSource
