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
    if test
        reg = Regex("$prefix")
        if !any(startswith("$x", reg) for x ∈ keys(props))
            return missing
        end
    end

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
