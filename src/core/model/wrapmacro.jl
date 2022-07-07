function _👻structure(
        cls     :: Symbol,
        parents :: Union{Symbol, Expr},
        fields  :: _👻Fields,
) :: Expr
    code   = [_👻initcode(cls, fields, i) for i ∈ _👻filter(fields)]
    fnames = map(x->x.name, _👻filter(fields))
    quote
        mutable struct $cls <: $parents
            id        :: Int64
            $((:($(i.name)::$(bokehstoragetype(i.type))) for i ∈ _👻filter(fields) if !i.alias)...)
            callbacks :: Vector{Function}

            function $cls(; id = $(@__MODULE__).ID(), kwa...)
                $(code...)
                new(
                    id isa Int64 ? id : parse(Int64, string(id)),
                    $(fnames...),
                    Function[],
                )
            end
        end
    end
end

function _👻setter(cls::Symbol, fields::_👻Fields) :: Expr
    code = _👻elseif_alias(fields, :(throw(ErrorException("unknown or read-only property $α")))) do i
        name = Meta.quot(i.name)
        set  = if i.js
            quote
                old = $(@__MODULE__).bokehunwrap(getproperty(μ, $name))
                dotrigger && BokehJL.Events.testcantrigger()
                new = setfield!(μ, $name, ν)
                dotrigger && BokehJL.Events.trigger(BokehJL.ModelChangedEvent(μ, $name, old, new))
            end
        else
            :(setfield!(µ, $name, ν))
        end

        if i.readonly
            set = quote
                patchdoc || throw(ErrorException($("$cls.$(i.name) is readonly")))
                $set
            end
        end

        quote
            ν = $(@__MODULE__).bokehconvert($(i.type), $(@__MODULE__).bokehunwrap(ν))
            (ν isa $Unknown) && throw(ErrorException("Could not convert `$ν` to $(i.type)"))
            $set
            getproperty(µ, $name)
        end
    end

    quote
        function Base.setproperty!(μ::$cls, α::Symbol, ν; dotrigger :: Bool = true, patchdoc :: Bool = false)
            $code
        end
    end
end

function _👻getter(cls::Symbol, fields::_👻Fields) :: Expr
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

function _👻propnames(cls::Symbol, fields::_👻Fields) :: Expr
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

function items(select::Symbol, sort::Bool)
end


function _👻funcs(cls::Symbol, fields::_👻Fields) :: Expr
    quote
        @inline function $(@__MODULE__).bokehproperties(::Type{$cls})
            return $(tuple((i.name for i ∈ fields if i.js)...))
        end

        @inline function $(@__MODULE__).hasbokehproperty(T::Type{$cls}, attr::Symbol) :: Bool
            $(_👻elseif((i for i ∈ fields if i.js), false) do field
                :(if attr ≡ $(Meta.quot(field.name))
                    true
                end)
            end)
        end

        @inline function $(@__MODULE__).bokehfieldtype(T::Type{$cls}, α::Symbol) :: Union{Nothing, Type}
            $(_👻elseif_alias(fields, :(throw("$T.$α does not exist"))) do field
                field.js ? field.type : nothing
            end)
        end

        function $(@__MODULE__).defaultvalue(::Type{$cls}, α::Symbol) :: Union{Some, Nothing}
            $(_👻elseif_alias(_👻defaultvalue, fields, nothing))
        end

        function $(@__MODULE__).bokehfields(::Type{$cls})
            return tuple($((
                Expr(:call, :(=>), Meta.quot(i.name), i.type)
                for i ∈ sort(fields; by = (x)->"$(x.name)")
                if i.js && !i.alias
            )...))
        end
    end
end

function _👻code(src, mod::Module, code::Expr) :: Expr
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """BokehJL structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning""" _module = mod _file = string(src.file) _line = src.line
    end
    @assert code.args[2] isa Expr "$(code.args[2]): BokehJL structure must have a parent (iHasProps, iModel?)"
    @assert code.args[2].head ≡ :(<:) "$(code.args[2]): BokehJL structure cannot be templated"

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
precompile(_👻code, (LineNumberNode, Module, Expr))

function bokehproperties end
function hasbokehproperty end
function bokehfieldtype end
function bokehfields end
function defaultvalue end

function themevalue(@nospecialize(𝑇::Type{<:iHasProps}), σ::Symbol) :: Union{Some, Nothing}
    dflt = BokehJL.Themes.theme(𝑇, σ)
    return isnothing(dflt) ? Model.defaultvalue(𝑇, σ) : dflt
end

const ID = bokehidmaker()

Base.repr(@nospecialize(mdl::iHasProps)) = "$(nameof(typeof(mdl)))(id = $(bokehid(mdl)))" 

export @wrap
precompile(Tuple{var"#@wrap", LineNumberNode, Module, Expr})
