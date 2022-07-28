function glyph(𝑇::Symbol, args...; kwargs...)
    opts = filter((x -> "$x"[1] ∈ 'A':'Z'), names(Models; all = true))
    if 𝑇 ∉ opts
        𝑇 = only(i for i ∈ opts if lowercase("$𝑇") == lowercase("$i"))
    end
    return glyph(getfield(Models, 𝑇), args...; kwargs...)
end

"""
    glyph(𝑇::Union{Symbol, Type{<:Models.iGlyph}}; kwargs...)

Create a glyph renderer given a glyph type or its name.
The kwargs should include all `glyphargs(𝑇)` at a minimum
"""
function glyph(𝑇::Type{<:Models.iGlyph}, args...; trait_color = missing, runchecks::Bool = true, kwa...)
    @nospecialize 𝑇 args
    kwargs = Dict{Symbol, Any}(kwa...)
    if length(args) ≡ 1 && Models.glyphargs(𝑇)[1:2] == (:x, :y)
        # Allows plotting `f(x) = y` with a single positional arg
        # the `else` clause would plot `f(y) = x`
        haskey(kwargs, :y) && throw(BokehException("`:y` is both in args and kwargs"))
        kwargs[:y] = args[1]
    else
        # provides python-like positional keywords.
        for (i, j) ∈ zip(Models.glyphargs(𝑇), args)
            haskey(kwargs, i) && throw(BokehException("`:$i` is both in args and kwargs"))
            kwargs[i] = j
        end
    end

    out    = Dict{Symbol, Any}(
       (i => pop!(kwargs, i) for i ∈ _👻RENDERER if i ∈ keys(kwargs))...,
       :data_source =>  _👻datasource!(kwargs, get(kwargs, :source, missing), 𝑇)
    )

    defaults = _👻visuals!(kwargs, 𝑇, false, trait_color, "")
    nonsel   = _👻visuals!(kwargs, 𝑇, false, trait_color, "nonselection_", defaults, Dict{Symbol, Any}(:alpha => _👻NSEL_ALPHA))
    sel      = _👻visuals!(kwargs, 𝑇, true,  trait_color, "selection_",    defaults)
    hover    = _👻visuals!(kwargs, 𝑇, true,  trait_color, "hover_",        defaults)
    muted    = _👻visuals!(kwargs, 𝑇, false, trait_color, "muted_",        defaults, Dict{Symbol, Any}(:alpha => _👻MUTED_ALPHA))

    create(x, d = :auto) = ismissing(x) ? d : 𝑇(; kwargs..., out..., x...)

    outp = Models.GlyphRenderer(;
        glyph              = create(defaults),
        nonselection_glyph = create(nonsel),
        selection_glyph    = create(sel),
        hover_glyph        = create(hover, nothing),
        muted_glyph        = create(muted),
        out...,
    )
    runchecks && _👻runchecks(outp)
    return outp
end

"""
    glyph!(fig::Models.Plot, rend::Models.GlyphRenderer; dotrigger :: Bool = true, kwa...)
    glyph!(fig::Models.Plot, 𝑇::Union{Symbol, Type{<:Models.iGlyph}}; dotrigger :: Bool = true, kwa...)

Create a glyph renderer given a glyph type or its name and add it to the plot.
The kwargs should include all `glyphargs(𝑇)` at a minimum
"""
function glyph!(fig::Models.Plot, rend::Models.GlyphRenderer; dotrigger :: Bool = true, kwa...)
    push!(fig.renderers, rend; dotrigger)
    _👻legend!(fig, rend, kwa; dotrigger)
    return rend
end

function glyph!(
        fig       :: Models.Plot,
        𝑇         :: Union{Symbol, Type{<:Models.iGlyph}},
        args...;
        dotrigger :: Bool = true,
        kwa...
)
    trait_color = let cnt = count(Base.Fix2(isa, Models.iGlyphRenderer), fig.renderers)
        _👻COLORS[min(length(_👻COLORS), 1+cnt)]
    end
    return glyph!(fig, glyph(𝑇, args...; trait_color, kwa...); dotrigger, kwa...)
end

using Printf
using ..Plotting

for meth ∈ methods(Models.glyphargs)
    cls = meth.sig.parameters[2].parameters[1]
    (cls <: Models.iGlyph) || continue

    let 𝐹 = Symbol(lowercase("$(nameof(cls))")), 𝐹! = Symbol("$(𝐹)!")
        fargs = (
            Model.bokehproperties(Models.FigureOptions)...,
            Model.bokehproperties(Models.Plot)...,
        )
        @eval function $𝐹!(fig::Models.Plot, args...; kwa...)
            @nospecialize fig args
            glyph!(fig, $cls, args...; kwa...)
        end
        @eval function $𝐹(args...; kwa...)
            @nospecialize args
            fig = Plotting.figure(; (i for i ∈ kwa if first(i) ∈ $fargs)...)
            glyph!(fig, $cls, args...; (i for i ∈ kwa if first(i) ∉ $fargs)..., dotrigger = false)
            fig
        end
        @eval export $𝐹!, $𝐹

        for n ∈ (𝐹, 𝐹!)
            doc = let io = IOBuffer()
                println(io)
                if ("$n")[end] ≡ '!'
                    println(io, "    $n(")
                    println(io, "        $(@sprintf "%-10s" :plot) :: Models.Plot,")
                else
                    println(io, "    $n(")
                end

                gargs = Models.glyphargs(cls)
                for i ∈ gargs
                    p𝑇 = @sprintf "%-50s" Union{AbstractArray, Model.bokehfieldtype(cls, i)}
                    print(io, "        $(@sprintf "%-10s" i) :: $p𝑇 = $(repr(something(Model.themevalue(cls, i))))")
                    println(io, i ≡ gargs[end] ? ';' : ',')
                end
                println(io, "        kwa...")
                println(io, "    )")
                println(io, "")
                if ("$n")[end] ≡ '!'
                    println(io, "Adds a `$(nameof(cls))` glyph to the `Plot`")
                else
                    println(io, "Creates a `Plot` with a `$(nameof(cls))` glyph")
                end
                String(take!(io))
            end

            eval(:(@doc($doc, $n)))
        end
    end
end

export glyph!, glyph
