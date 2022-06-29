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
            (name, type)    = (line.head ≡ :(::) ? line : line.args[1]).args
            realtype        = mod.eval(type)
            (default, init) = _👻defaultvalue(realtype, line)
            (;
                index, name,
                type     = realtype,
                default, init,
                js       = !(realtype <: Internal),
                alias    = realtype <: Alias,
                readonly = realtype <: Union{
                    ReadOnly, Internal{<:ReadOnly}, iSpec{<:ReadOnly}, Container{<:ReadOnly}
                },
                child    = realtype <: Union{iModel, Nullable{<:iModel}},
                children = if realtype <: CONTAINERS
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

function _👻defaultvalue(T::Type, line::Expr)
    if line.head ≡ :(::)
        out = _👻defaultvalue(T)
        return (out, out)
    elseif line.args[2] ≡ :nodefaults
        return nothing, nothing
    elseif line.args[2] ≡ :zero
        out = _👻defaultvalue(T)
        if isnothing(out)
            R = bokehstoragetype(T)
            throw(ErrorException("Unknown defaults for $R (calls `zero($R)` or `$R()` are unavailable)"))
        end
        return out, out
    end
     
    expr = line.args[2]
    if expr isa Expr && expr.head ≡ :call && expr.args[1] ≡ :new
        return nothing, expr.args[2]
    end
    return Some(expr), Some(expr)
end

function _👻defaultvalue(T::Type)
    R = bokehstoragetype(T)
    applicable(zero, R) ? Some(:(zero($R))) : applicable(R) ? Some(:($R())) : nothing
end

function _👻defaultvalue(field::NamedTuple)
    isnothing(field.default) ? nothing : :(Some($(something(field.default))))
end

function _👻initcode(cls, fields::Vector{<:NamedTuple}, field::NamedTuple)
    opts = [j.name for j ∈ fields if j.alias && j.type.parameters[1] ≡ field.name]
    κ    = Meta.quot(field.name)
    val  = if isnothing(field.init)
        :(let val = Bokeh.Themes.theme($cls, $κ)
            isnothing(val) && throw(ErrorException(($("$cls.$(field.name) is a mandatory argument"))))
            something(val)
        end)
    else
        :(let val = Bokeh.Themes.theme($cls, $κ)
            isnothing(val) ? $(something(field.init)) : something(val)
        end)
    end
        
    val = _👻elseif((field.name, opts...), val) do key
        sκ = Meta.quot(key)
        :(if haskey(kwa, $sκ)
            kwa[$sκ]
        end)
    end

    return if field.type <: Internal
        :($(field.name) = $val)
    else
        x = gensym()
        y = gensym()
        quote
            $(field.name) = let $x = $val, $y = $(@__MODULE__).bokehconvert($(field.type), $x)
                ($y isa $Unknown) && throw(ErrorException(string(
                    "Could not convert `", $x, "` to ",
                    $cls, ".", $("$(field.name)"),
                    "::", $(bokehstoragetype(field.type))
                )))
                @assert $y isa fieldtype($cls, $κ) string($("$cls.$(field.name) != "), typeof($y))
                $y
            end
        end
    end
end
