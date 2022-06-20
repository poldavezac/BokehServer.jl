function _👻structure(
        cls     :: Symbol,
        parents :: Union{Symbol, Expr},
        fields  :: Vector{<:NamedTuple},
)
    aliases = [i.name => i.type.parameters[1] for i ∈ fields if i.alias]

    function initcode(field)
        opts = [first(j) for j ∈ aliases if last(j) ≡ field.name]
        κ    = Meta.quot(field.name)
        val  = if isnothing(field.default)
            :(let val = Bokeh.Themes.theme($cls, $κ)
                isnothing(val) && throw(ErrorException(($("$cls.$(field.name) is a mandatory argument"))))
                something(val)
            end)
        else
            :(let val = Bokeh.Themes.theme($cls, $κ)
                isnothing(val) ? $(something(field.default)) : something(val)
            end)
        end
            
        val = _👻elseif((field.name, opts...), val) do key
            κ = Meta.quot(key)
            :(if haskey(kwa, $κ)
                kwa[$κ]
            end)
        end

        return if field.type <: Internal
            val
        else
            quote
                let x = $val
                    y = $(@__MODULE__).bokehconvert($(field.type), x)
                    (y isa $Unknown) && throw(ErrorException(string(
                        "Could not convert `", x, "` to ",
                        $cls, ".", $("$(field.name)"),
                        "::", $(bokehfieldtype(field.type))
                    )))
                    y
                end
            end
        end
    end

    quote
        mutable struct $cls <: $parents
            id        :: Int64
            $((:($(i.name)::$(bokehfieldtype(i.type))) for i ∈ _👻filter(fields) if !i.alias)...)
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
                ν = $(@__MODULE__).bokehconvert($(i.type), $(@__MODULE__).bokehrawtype(ν))
                (ν isa $Unknown) && throw(ErrorException("Could not convert `$ν` to $(i.type)"))
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

macro wrap(expr::Expr)
    _👻code(__source__, __module__, expr)
end

function bokehproperties end
function hasbokehproperty end
function bokehpropertytype end
function bokehfields end
function defaultvalue end

const ID = bokehidmaker()

Base.repr(mdl::T) where {T <: iHasProps} = "$T(id = $(bokehid(mdl)))" 

export @wrap
