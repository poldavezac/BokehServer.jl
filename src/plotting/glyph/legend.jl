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
            legend = first(opts)
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
