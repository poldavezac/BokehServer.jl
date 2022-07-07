module GlyphPlotting
using ...AbstractTypes
using ...Model
using ...Models

function glyph(𝑇::Symbol; kwargs...)
    opts = filter((x -> "$x"[1] ∈ 'A':'Z'), names(Models; all = true))
    if 𝑇 ∉ opts
        𝑇 = only(i for i ∈ opts if lowercase("$𝑇") == lowercase("$i"))
    end
    return glyph(getfield(Models, 𝑇); kwargs...)
end

"""
    glyph(𝑇::Union{Symbol, Type{<:Models.iGlyph}}; kwargs...)

Create a glyph renderer given a glyph type or its name.
The kwargs should include all `glyphargs(𝑇)` at a minimum
"""
function glyph(𝑇::Type{<:Models.iGlyph}; trait_color = missing, kwa...)
    kwargs = Dict{Symbol, Any}(kwa...)
    out    = Dict{Symbol, Any}(
       (i => pop!(kwargs, i) for i ∈ _👻RENDERER if i ∈ keys(kwargs))...,
       :data_source =>  _👻datasource!(kwargs, get(kwargs, :source, missing), 𝑇)
    )

    defaults = _👻visuals!(kwargs, 𝑇; trait_color)
    nonsel   = _👻visuals!(kwargs, 𝑇; trait_color, prefix = :nonselection_, defaults, override = (; alpha = _👻NSEL_ALPHA))
    sel      = _👻visuals!(kwargs, 𝑇; trait_color, prefix = :selection_, defaults, test = true)
    hover    = _👻visuals!(kwargs, 𝑇; trait_color, prefix = :hover_, defaults, test = true)
    muted    = _👻visuals!(kwargs, 𝑇; trait_color, prefix = :muted_, defaults, override = (; alpha = _👻MUTED_ALPHA))

    create(x) = ismissing(x) ? :auto : 𝑇(; kwargs..., out..., x...)

    return Models.GlyphRenderer(;
        glyph              = create(defaults),
        nonselection_glyph = create(nonsel),
        selection_glyph    = create(sel),
        hover_glyph        = ismissing(hover) ? nothing : hover,
        muted_glyph        = create(muted),
        out...,
    )
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
        𝑇         :: Union{Symbol, Type{<:Models.iGlyph}};
        dotrigger :: Bool = true,
        kwa...
)
    trait_color = let cnt = count(Base.Fix2(isa, Models.iGlyphRenderer), fig.renderers)
        _👻COLORS[min(length(_👻COLORS), 1+cnt)]
    end
    return glyph!(fig, glyph(𝑇; trait_color, kwa...); dotrigger, kwa...)
end

const _👻MUTED_ALPHA = .2
const _👻NSEL_ALPHA  = .1
const _👻TEXT_COLOR  = :black
const _👻LEGEND      = (:legend_field, :legend_group, :legend_label)
const _👻VISUALS     = (:line, :hatch, :fill, :text, :global)
const _👻PREFIXES    = (:nonselection, :hover, :muted, :selection)
const _👻RENDERER    = (:name, :coordinates, :x_range_name, :y_range_name, :level, :view, :visible, :muted)
const _👻COLORS      = (
    "#1f77b4",
    "#ff7f0e", "#ffbb78",
    "#2ca02c", "#98df8a",
    "#d62728", "#ff9896",
    "#9467bd", "#c5b0d5",
    "#8c564b", "#c49c94",
    "#e377c2", "#f7b6d2",
    "#7f7f7f",
    "#bcbd22", "#dbdb8d",
    "#17becf", "#9edae5"
)

"""
    _👻datasource!(𝐹::Function, kwargs, 𝑇::Type)

iterate over all iSpec properties and see what to do with the data_source
"""
function _👻datasource!(𝐹::Function, kwargs, 𝑇::Type)
    pairs = Tuple{Symbol, Any, Type}[]

    # look through iSpec properties, deal with arrays
    for col ∈ Model.bokehproperties(𝑇)
        p𝑇  = Model.bokehfieldtype(𝑇, col)
        (p𝑇 <: Model.iSpec) || continue

        if haskey(kwargs, col)
            arg = kwargs[col]
        elseif col ∈ Models.glyphargs(𝑇)
            val = Model.themevalue(𝑇, col)
            isnothing(val) && throw(ErrorException("Missing argument $𝑇.$col"))
            arg = something(val)
        else
            continue
        end
        push!(pairs, (col, arg, p𝑇))
    end

    # deal with color & alpha ...
    for (col, arg) ∈ collect(kwargs)
        (arg isa AbstractVector) || continue
        Model.hasbokehproperty(𝑇, col) && continue

        # check whether col is trait (color, alpha, ...)
        opts = [Symbol("$(i)_$col") for i ∈ _👻VISUALS if Model.hasbokehproperty(𝑇, Symbol("$(i)_$col"))]
        if isempty(opts)
            # check whether col is specification (muted_line_color, ...)
            val  = "$col"
            if count(val, '_') ≡ 2
                elems  = split(val, '_')
                newcol = Symbol("$(elems[2])_$(elems[3])")
                if Symbol(elems[1]) ∈ _👻PREFIXES && Model.hasbokehproperty(𝑇, newcol)
                    opts = [opts]
                end
            end
        end
        types = Set{Type}(Model.bokehfieldtype(𝑇, i ) for i ∈ opts)
        (length(types) ≢ 1 || !(first(types) <: Model.iSpec))  && continue

        push!(pairs, (col, arg, first(types)))
    end

    for (col, arg, p𝑇) ∈ pairs
        cnv = Model.bokehconvert(p𝑇, arg)
        msg = if cnv isa Model.Unknown && !(arg isa AbstractArray)
            "is not a supported type $(typeof(arg)) = $arg"
        else
            𝐹(col, arg, cnv, p𝑇)
        end

        (msg isa Exception) && throw(ErrorException("Argument for $𝑇.$col $(msg.msg)"))
        (msg ≡ arg) || push!(kwargs, col => msg)
    end
end

"""
    _👻datasource!(kwargs::Dict{Symbol}, ::Missing, 𝑇::Type)

iterate over all iSpec properties and create a data_source
"""
function _👻datasource!(kwargs::Dict{Symbol}, ::Missing, 𝑇::Type)
    data = Dict{String, AbstractArray}()

    # add missing :x or :y
    if (:x, :y) ⊆ Models.glyphargs(𝑇)
        if !haskey(kwargs, :x) && get(kwargs, :y, nothing) isa AbstractArray
            kwargs[:x] = 1:length(kwargs[:y])
        elseif !haskey(kwargs, :y) && get(kwargs, :x, nothing) isa AbstractArray
            kwargs[:y] = 1:length(kwargs[:x])
        end
    end

    _👻datasource!(kwargs, 𝑇) do col, arg, cnv, p𝑇
        if cnv isa Model.iSpec && !ismissing(cnv.field)
            ErrorException("has a source-type entry, yet no source was provided")
        elseif cnv isa Model.Unknown && arg isa AbstractArray
            data["$col"] = Model.datadictarray(p𝑇, arg)
            (; field = "$col")
        else
            arg
        end
    end

    return Models.ColumnDataSource(; data)
end

"""
    _👻datasource!(kwargs::Dict{Symbol}, src::Models.ColumnDataSource, 𝑇::Type)

iterate over all iSpec properties and check that the provided fields are in the data_source
"""
function _👻datasource!(kwargs::Dict{Symbol}, src::Models.ColumnDataSource, 𝑇::Type)
    data = src.data
    _👻datasource!(kwargs, 𝑇) do col, arg, cnv, _
        if arg isa AbstractArray
            ErrorException("is a vector even though a data source has also been provided")
        elseif cnv isa Model.iSpec && !ismissing(cnv.field) && !haskey(data, cnv.field)
            ErrorException("is a missing or miss-spelled column '$(cnv.field)'")
        else
            arg
        end
    end
    return src
end

function _👻datasource!(kwargs::Dict{Symbol}, src::AbstractDict, 𝑇::Type)
    _👻datasource!(kwargs, Models.ColumnDataSource(; data = Model.bokehconvert(DataDict, src)), 𝑇)
end

function _👻visuals!(
        props::Dict{Symbol},
        𝑇::Type{<:Models.iGlyph};
        trait_alpha      = 1.,
        text_color       = _👻TEXT_COLOR,
        trait_color      = missing,
        prefix           = "",
        defaults         = (;),
        override         = (;),
        test     :: Bool = false
)
    test && !any(startswith("$prefix", "$x") for x ∈ keys(props)) && return missing

    defaults       = merge((; text_color, hatch_color = text_color), defaults)
    trait_defaults = (; color = (ismissing(trait_color) ? _👻COLORS[1] : trait_color), alpha = trait_alpha)

    result = Dict{Symbol, Any}()
    traits = Set{Symbol}()
    names  = Model.bokehproperties(𝑇)

    for name ∈ names
        trait  = let val = "$name"
            if count('_', val) ≢ 1
                nothing
            else
                (left, right) = Symbol.(split(val, '_'))
                left ∈  _👻VISUALS ? right : nothing
            end
        end
        isnothing(trait) && continue

        # e.g. not specificed anywhere
        out = get(trait_defaults, trait, missing)

        # e.g use values off the main glyph
        out = get(defaults, name, out)

        # e.g. an alpha to use for nonselection if none is provided
        out = get(override, trait, out)

        if trait ∉ names
            # e.g. "nonselection_alpha"
            key = Symbol("$(prefix)$trait")
            out = get(props, key, out)
            push!(traits, key)
        end

        # e.g. "line_color", "selection_fill_alpha"
        out  = get(props, Symbol("$(prefix)$name"), out)

        ismissing(out) || (result[name] = out)
    end


    foreach(x->pop!(props, x, nothing), traits)
    return result
end

function _👻legend!(fig::Models.Plot, rend::Models.GlyphRenderer, kwa; dotrigger :: Bool = true)
    haskey(kwa, :legend) && throw(ErrorException("Use one of keywords $_👻LEGEND"))
    count(∈(_👻LEGEND), keys(kwa)) > 1 && throw(ErrorException("Only one keyword allowed amongst $_👻LEGEND"))

    if any(∈(_👻LEGEND), keys(kwa))
        opts = [i for j ∈ (:center, :above, :below, :left, :right) for i ∈ getproperty(fig, j) if i isa Models.iLegend]
        (length(opts) > 1) && throw(ErrorException("Too many `Legend` objects to use the `legend_` keywords"))

        if isempty(opts)
            legend = Models.Legend()
            push!(fig.center, legend; dotrigger)
            dotrigger = false
        else
            legend = first(legend)
        end

        val = only(j for (i, j) ∈ pairs(kwa) if i ∈ _👻LEGEND)
        (val isa AbstractString) || throw(ErrorException("Keywords $_👻LEGEND only accept strings"))

        if haskey(kwa, :legend_label) || haskey(kwa, :legend_field)
            label = haskey(kwa, :legend_field) ? (; field = "$val") : (; value = "$val")
            itm   = filter(x -> x.label == label, legend.items)
            if isempty(itm)
                push!(legend.items, Models.LegendItem(; label, renderers = [rend]); dotrigger)
            else
                for x ∈ itm
                    push!(x.renderers, rend; dotrigger)
                end
            end
        else
            src = rend.data_source
            haskey(src.data, val) || throw(ErrorException("Missing columns for :legend_group keyword"))
            done = Set{String}()
            for (i, j) ∈ enumerate(src.data[val])
                ("$j" ∈ done) && continue
                push!(
                    legend[1].items,
                    Models.LegendItem(; label = (; value = "$j"), index = i, renderers = [rend]);
                    dotrigger
                )
                push!(done, "$j")
            end
        end
    end

    return rend
end

end

using .GlyphPlotting: glyph!, glyph

using Printf
for meth ∈ methods(Models.glyphargs)
    cls = meth.sig.parameters[2].parameters[1]
    (cls <: Models.iGlyph) || continue

    let 𝐹 = Symbol(lowercase("$(nameof(cls))")), 𝐹! = Symbol("$(𝐹)!")
        fargs = Model.bokehproperties(Models.FigureOptions)
        @eval $𝐹!(fig::Models.Plot; kwa...) = glyph!(fig, $cls; kwa...)
        @eval function $𝐹(; kwa...)
            fig = figure(; (i for i ∈ kwa if first(i) ∈ $fargs)...)
            glyph!(fig, $cls; (i for i ∈ kwa if first(i) ∉ $fargs)..., dotrigger = false)
            fig
        end
        @eval export $𝐹!, $𝐹

        for n ∈ (𝐹, 𝐹!)
            doc = let io = IOBuffer()
                println(io)
                if ("$n")[end] ≡ '!'
                    println(io, "    $n(")
                    println(io, "        $(@sprintf "%-10s" :plot) :: Models.Plot;")
                else
                    println(io, "    $n(;")
                end
                for i ∈ Models.glyphargs(cls)
                    p𝑇 = @sprintf "%-50s" Union{AbstractArray, Model.bokehfieldtype(cls, i)}
                    println(io, "        $(@sprintf "%-10s" i) :: $p𝑇 = $(repr(something(Model.themevalue(cls, i)))),")
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
