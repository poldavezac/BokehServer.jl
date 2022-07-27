function _👻structure(
        cls     :: Symbol,
        parents :: Union{Symbol, Expr},
        fields  :: _👻Fields,
) :: Expr
    vals  = [_👻initcode(cls, fields, i) for i ∈ _👻filter(fields)]
    cstr  =  if all(last(i) ≡ :default for i ∈ vals)
        quote
            $cls(; id = $(@__MODULE__).ID(), kwa...) = $(@__MODULE__)._👻init($cls, id, kwa)
        end
    else
        if any(last(i) ≡ :custom for i ∈ vals)
            fnames = map(x->x.name, _👻filter(fields))
            code   = first.(vals)
        else
            fnames = [i[1].args[2] for i ∈ vals]
            code   = ()
        end
        quote
            function $cls(; id = $(@__MODULE__).ID(), kwa...)
                $(code...)
                $cls(
                    id isa Int64 ? id : parse(Int64, string(id)),
                    $(fnames...),
                    Function[],
                )
            end
        end
    end
    quote
        mutable struct $cls <: $parents
            id        :: Int64
            $((:($(i.name)::$(bokehstoragetype(i.type))) for i ∈ _👻filter(fields) if !i.alias)...)
            callbacks :: Vector{Function}
        end

        $cstr
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

function _👻funcs(cls::Symbol, fields::_👻Fields) :: Expr
    bkalias = if any(i.alias for i ∈ fields)
        quote
            @inline function $(@__MODULE__).bokehalias(::Type{$cls}, α::Symbol) :: Symbol
                return $(_👻elseif((i for i ∈ fields if i.js), :α) do field
                    if field.alias
                        :(if α ≡ $(Meta.quot(field.name))
                            $(Meta.quot(field.type.parameters[1]))
                        end)
                    else
                        nothing
                    end
                end)
            end
        end
    else
        nothing
    end

    quote
        $bkalias

        @inline $(@__MODULE__).bokehinfo(::Type{$cls}) = $(tuple(fields...))

        @inline function $(@__MODULE__).bokehproperties(::Type{$cls}) :: Tuple{Vararg{Symbol}}
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
            $(_👻elseif_alias(fields, nothing) do field
                field.js ? field.type : nothing
            end)
        end

        function $(@__MODULE__).defaultvalue(::Type{$cls}, α::Symbol) :: Union{Some, Nothing}
            $(_👻elseif_alias(_👻defaultvalue, fields, nothing))
        end

        function $(@__MODULE__).bokehfields(::Type{$cls}) :: Tuple{Vararg{Pair{Symbol, Type}}}
            return tuple($((
                :(Pair{Symbol, Type}($(Meta.quot(i.name)), $(i.type)))
                for i ∈ sort(fields; by = (x)->"$(x.name)")
                if i.js && !i.alias
            )...))
        end
    end
end

function _👻code(src, mod::Module, code::Expr) :: Expr
    @assert code.head ≡ :struct
    if !code.args[1]
        @warn """BokehServer structure $mod.$(code.args[2]) is set to mutable.
        Add `mutable` to disable this warning""" _module = mod _file = string(src.file) _line = src.line
    end
    @assert code.args[2] isa Expr "$(code.args[2]): BokehServer structure must have a parent (iHasProps, iModel?)"
    @assert code.args[2].head ≡ :(<:) "$(code.args[2]): BokehServer structure cannot be templated"

    code.args[1] = true
    fields  = _👻fields(mod, code)
    parents = code.args[2].args[2]
    cls     = code.args[2].args[1]
    if cls isa Expr
        cls = mod.eval(cls.head ≡ :($) ? cls.args[1] : cls) 
    end

    # use iXXX instead of XXX when constructing `BokehServer.Models` structures.
    # This allows overloading the properties
    parent = nameof(mod) ≡ :Models && nameof(parentmodule(mod)) ≡ :BokehServer ? Symbol("i$cls") : cls
    (parent ∈ names(mod; all = true)) || (parent = cls)
    esc(quote
        @Base.__doc__ $(_👻structure(cls, parents, fields))

        $(_👻propnames(parent, fields))
        $(_👻funcs(cls, fields))
        push!($(@__MODULE__).MODEL_TYPES, $cls)
        $cls
    end)
end

macro wrap(expr::Expr)
    _👻code(__source__, __module__, expr)
end
precompile(_👻code, (LineNumberNode, Module, Expr))

"""
    bokehproperties(::Type{iHasProps}) :: Tuple{Vararg{Symbol}}

Return a list of existing fields, much like `fieldnames`, but only for *javascript* aware fields.
"""
function bokehproperties end

"""
    hasbokehproperty(::Type{iHasProps}) :: Bool

Return whether a field exists, much like `hasfield`, but only for *javascript* aware fields.
"""
function hasbokehproperty end

"""
    bokehfieldtype(::Type{iHasProps}) :: Type

Return the field type, much like `fieldtype`, but only for *javascript* aware fields.
"""
function bokehfieldtype end

"""
    bokehfields(::Type{iHasProps}) :: Tuple{Vararg{Pair{Symbol, Type}}}

Return tuples (symbol, type) for each field in the structure which is known to
javascript.
"""
function bokehfields end

"""
    defaultvalue(::iHasProps, ::Symbol) :: Union{Nothing, Some}

Return `Some(default value)` for a given field in a given object if a default value was 
provided with the structure definition. Return `nothing` otherwise.

**Warning** This is *not* necessarily the theme default. See `themevalue` for the latter.
"""
function defaultvalue end

function bokehinfo end

bokehalias(::Type, α::Symbol) = α

function Base.getproperty(μ::iHasProps, α::Symbol)
    α  = bokehalias(typeof(μ), α)
    ν  = getfield(μ, α)
    f𝑇 = bokehfieldtype(typeof(μ), α)
    return isnothing(f𝑇) ? ν : bokehread(f𝑇, μ, α, ν)
end

function Base.setproperty!(μ::iHasProps, α::Symbol, ν; dotrigger :: Bool = true, patchdoc :: Bool = false)
    α  = bokehalias(typeof(μ), α)
    f𝑇 = bokehfieldtype(typeof(μ), α)

    isnothing(f𝑇) && return setfield!(μ, α, ν)

    (f𝑇 <: ReadOnly) && !patchdoc && throw(ErrorException("$(typeof(μ)).$α is readonly"))

    cν  = bokehconvert(f𝑇, bokehunwrap(ν))
    (cν isa Unknown) && throw(ErrorException("Could not convert `$ν` to $f𝑇"))

    old = getfield(μ, α)
    dotrigger && BokehServer.Events.testcantrigger()
    new = setfield!(μ, α, cν)
    dotrigger && BokehServer.Events.trigger(BokehServer.ModelChangedEvent(μ, α, old, new))
    return new
end

function themevalue(@nospecialize(𝑇::Type{<:iHasProps}), σ::Symbol) :: Union{Some, Nothing}
    dflt = BokehServer.Themes.theme(𝑇, σ)
    return isnothing(dflt) ? Model.defaultvalue(𝑇, σ) : dflt
end

const ID = bokehidmaker()

Base.repr(@nospecialize(mdl::iHasProps)) = "$(nameof(typeof(mdl)))(id = $(bokehid(mdl)))" 

export @wrap
precompile(Tuple{var"#@wrap", LineNumberNode, Module, Expr})
