module Models

abstract type iModel end
abstract type iSourcedModel <: iModel end

struct Column
    column :: String 

    Column(x::Union{AbstractString, Symbol}) = new(string(x))
end

macro col_str(x) Column(x) end

function _model_fields(code, opts::Vararg{Regex})
    isjs = if isempty(opts)
        # all fields are bokeh fields
        (_)->true
    else
        # select fields mentioned in `args` as bokeh fields
        (x)-> let val = "$x"
            !all(isnothing(match(r, val)) for r ∈ opts)
        end
    end

    # filter expressions :(x::X) and :(x::X = y)
    isfield(x) = if !Meta.isexpr(x)
        false
    elseif x.head ≡ :(::)
        true
    else
        Meta.isexpr(i.args[1]) && i.args[1].head ≡ :(::)
    end

    # create a named tuple containing all relevant info
    # for both means of defining a struture field
    [
        begin
            (name, type) = (o.head ≡ :(::) ? o : o.args[1]).args

            (;
                index,
                name,
                type,
                default  = o.head ≡ :(::) ? nothing : Some(o.args[2]),
                js       = isjs(name),
                child    = type <: iModel,
                children = eltype(type) <: iModel
            )
        end
        for (index, line) ∈ enumerate(code.args)
        if isfield(line)
    ]
end

_model_srccls(cls::Symbol, hassource :: Bool) =  hassource ? (Symbol("Src$cls"),) : ()

function _model_srccls(cls::Symbol, fields::Vector{<:NamedTuple}, hassource :: Bool)
    if hassource
        :(@Base.kwdef mutable struct $(Symbol("Src$cls"))
            source :: Any = nothing
            $((
                :($(i.name) :: Union{Symbol, Nothing} = nothing)
                for i ∈ fields if i.isjs
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
        $((:($(i.name) :: Vector{Function}) for i ∈ fields if i.isjs)...)
        $cbcls() = new((Function[] for _ ∈ 1:$(sum(1 for i ∈ fields if i.js)))...)
    end)
end

_model_bkcls(cls::Symbol) = Symbol("Bk$cls")

function _model_bkcls(cls::Symbol, fields::Vector{<:NamedTuple}, hassource :: Bool)
    bkcls = _model_bkcls(cls::Symbol)
    :(mutable struct $bkcls <: $(hassource ? :iSourcedModel : :iModel)
        id        :: Int64
        values    :: $name
        callbacks :: $(_model_cbcls(cls))
        $(_model_srccls(cls, hassource)...)
    end)
end

function _model_code(code::Expr, hassource :: Bool, opts::Vararg{Regex})
    @assert code.head ≡ :struct
    fields = _model_fields(code, opts...)

    # remove default part from the field lines
    for field ∈ fields
        if !isnothing(field.default)
            code.args[field.index] = code.args[field.index].args[1]
        end
    end

    cls    = code.args[2] isa Symbol ? code.args[2] : code.args[2].args[1] 
    bkcls  = _model_bkcls(cls)
    params = Expr(
        :parameters,
        [
            i.default ≡ none ? Expr(:kw, i.name) : Expr(:kw, i.name, i.default)
            for i ∈ fields
        ]
    )
    quote
        $code

        $cls(; $params) = $cls($(getindex.(fields, 0)...))

        $(_model_srccls(cls, fields, hassource))
        $(_model_cbcls(cls, fields))
        $(_model_bkcls(cls, fields, hassource))

        $bkcls(; id :: Int64 = newmodelid(), $params) = $bkcls(
            id,
            $cls($(getindex.(fields, 0)...)),
            $(_model_cbcls(cls))(),
            $((:($i()) for i ∈ _model_srccls(cls, hassource))...)
        )

        modeltype(::Type{$cls}) = $bkcls
        modeltype(::Type{$bkcls}) = $cls
        sourcetype(::Type{$cls}) = $(hassource ? Nothing : _model_srccls(cls, true)[1])
        @inline jsproperties(::Type{$cls}) = $(((Meta.quote(i.name) for i ∈ fields if i.js)...))
        @inline function jsproperties(::Type{$bkcls}; select::Symbol = :all)
            if select ≡ :children
                $(((Meta.quote(i.name) for i ∈ fields if i.js && i.children)...))
            elseif select ≡ :child
                $(((Meta.quote(i.name) for i ∈ fields if i.js && i.child)...))
            else
                $(((Meta.quote(i.name) for i ∈ fields if i.js)...))
            end
        end
    end
end

macro model(cls::Expr, args::Vararg{Union{Expr, String, Symbol}})
    @assert cls.head ≡ :struct
    hassource = any(i ≡ :(source = true) for i ∈ args if Meta.isexpr(i))
    _model_code(cls, hassource, (Regex(string(i)) for i ∈ args if i isa Union{String, Symbol})...)
end

for (tpe, others) ∈ (iModel => (), iSourcedModel => (:data_source,)) 
    @eval function Base.propertynames(μ::$tpe; private::Bool = false)
        return if private
            (propertynames(getfield(μ, :values))..., fieldnames(μ)..., $(Meta.quot.(others)...), :id)
        else
            (propertynames(getfield(μ, :values))..., $(Meta.quot.(others)...))
        end
    end
end

function Base.getproperty(μ::T, α::Symbol) where {T <: iModel}
    if α ∈ fieldnames(T)
        return getfield(μ, α)
    elseif α ≡ :data_source
        return getfield(μ, :sourced).source
    elseif α ∈ jsproperties(T)
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
) where {T <: iModel}
    return if α ∈ fieldnames(T)
        setfield!(μ, α, υ)
    elseif α ≡ :data_source
        setfield!(getfield(μ, :sourced), :source, υ)
    elseif α ∈ jsproperties(T)
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

        type = modeltype(typeof(cur))
        for field ∈ jsproperties(typeof(cur); child = true)
            attr = getproperty(cur, field)
            push!(todos, attr)
            found[modelid(attr)] = attr
        end

        for field ∈ jsproperties(typeof(cur); children = true)
            append!(todos, attr)
            for child ∈ attr
                found[modelid(child)] = child
            end
        end
    end
    found
end

export iModel, iSourcedModel, @model, Column, @col_str, allmodels
end

using .Models
