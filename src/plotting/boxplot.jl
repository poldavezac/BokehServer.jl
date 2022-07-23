using StatsBase

struct BoxPlotItem{K, T}
    key       :: K
    quantiles :: Tuple{T, T, T}
    iqr       :: Tuple{T, T}
    aberrant  :: Vector{T}
    barwidth  :: Float64
    count     :: Int64
end

@Base.kwdef struct BoxPlotConfig
    ranges      :: Vector{Float64}          = [.25, .5, .75]
    iqr         :: Float64                  = 1.5
    barwidth    :: Float64                  = .9
    keepmissing :: Bool                     = true
    sortby      :: Union{Nothing, Function} = count
    rev         :: Bool                     = true
end

function BoxPlotItem(
        config   :: BoxPlotConfig, 
        key,
        arr      :: AbstractVector;
        sorted   :: Bool          = false,
)
    sorted || sort!(arr)
    quants = quantile!(arr, config.ranges; sorted = true)
    dist   = config.iqr * (quants[3]-quants[1])
    iqr1   = clamp(searchsortedfirst(arr, quants[2]-dist), 1, length(arr))
    iqr2   = clamp(searchsortedlast(arr, quants[2]+dist), 1, length(arr))
    BoxPlotItem(
        key,
        tuple(quants...),
        (arr[iqr1], arr[iqr2]),
        append!(arr[1:iqr1-1], @view arr[iqr2+1:end]),
        config.barwidth,
        length(arr)
    )
end

Base.count(x::BoxPlotItem) = x.count
StatsBase.median(x::BoxPlotItem) = x.quantiles[2]

function boxplotitems(config::BoxPlotConfig, labels, values) :: Vector{<:BoxPlotItem}
    items = Dict{eltype(labels), Vector{eltype(values)}}()
    for (i, j) ∈ zip(labels, values)
        (isnothing(i) || isnothing(j)) && continue
        !config.keepmissing && (ismissing(i) || ismissing(j)) && continue
        push!(
            get!(items, i) do
                eltype(values)[]
            end,
            j
        )
    end

    return boxplotitems(config, items)
end

function boxplotitems(config::BoxPlotConfig, items; kw...) :: Vector{<:BoxPlotItem}
    return boxplotitems(config, [BoxPlotItem(config, i, j) for (i, j) ∈ items])
end

function boxplotitems(config::BoxPlotConfig, boxes::Vector{<:BoxPlotItem}) :: Vector{<:BoxPlotItem}
    return if config.sortby ≡ keys
        sort!(boxes; by = (x) -> x.key)
    elseif config.sortby isa Function
        sort!(boxes; by = config.sortby, config.rev)
    else
        boxes
    end
end

function boxplotitems(a...; kw...) :: Vector{<:BoxPlotItem}
    config = BoxPlotConfig(; (i for i ∈ kw if hasfield(BoxPlotConfig, first(i)))...)
    return boxplotitems(config, a...)
end

"""
    boxplot!(
        plot::Models.Plot,
        labels,
        values;
        direction   :: Symbol          = :vertical,
        sortby      :: Function        = count,
        skipmissing :: Bool            = true,
        ranges      :: Vector{Float64} = [.25, .5, .75],
        iqr         :: Float64         = 1.5,
        bar      = (; line_color = :black, fill_color = :lightskyblue),
        segments = (; line_color = :black),
        borders  = (; marker = :dash, color = :black),
        aberrant = (; marker = :circle, color = :lightskyblue),
    )

    boxplot!(
        plot::Models.Plot,
        boxes::AbstractVector{<:BoxPlotItem};
        direction   :: Symbol          = :vertical,
        sortby      :: Function        = count,
        bar      = (; line_color = :black, fill_color = :lightskyblue),
        segments = (; line_color = :black),
        borders  = (; marker = :dash, color = :black),
        aberrant = (; marker = :circle, color = :lightskyblue),
    )

Create a boxplot for every label.

The labels can be sorted by (use argument sortby with a function):
* count: the number of values per box
* median: the median of values per box
* keys: the box key value

```julia
BokehServer.html() do
    labels = [j == 1 ? "x" : "y" for j = 1:2 for _ = 1:(j*10)]
    vals   = [(randn(Float64, 10) .+ 10.)..., (randn(Float64, 20) .- 10.)...]
    BokehServer.boxplot(labels, vals)
end
```
"""
function boxplot!(
        plot::Models.Plot,
        a...;
        dotrigger :: Bool     = true,
        direction :: Symbol   = :vertical,
        bar                   = (; line_color = :black, fill_color = :lightskyblue),
        segments              = (; line_color = :black),
        borders               = (; marker     = :dash, color   = :black),
        aberrant              = (; marker     = :circle, color = :lightskyblue),
        kw...
)
    boxes   = boxplotitems(a...; kw...)
    results = Models.GlyphRenderer[]

    kwargs(x, y) = (
        (k for k ∈ kw if hasfield(getfield(Models, x), first(k)))...,
        pairs(y)...,
        :dotrigger => dotrigger
    )

    # bar from q1 to q3
    isnothing(bar) || let source = Dict(
            "key"      => [i.key for i ∈ boxes],
            "q1"       => [i.quantiles[1] for i ∈ boxes],
            "q3"       => [i.quantiles[3] for i ∈ boxes],
            "barwidth" => [i.barwidth for i ∈ boxes],
        )
        push!(
            results,
            if direction ≡ :vertical
                vbar!(
                    plot; kwargs(:VBar, bar)...,
                    source, x = "key", bottom = "q1", top = "q3", width = "barwidth"
                )
            else
                hbar!(
                    plot; kwargs(:HBar, bar)...,
                    source, y = "key", left = "q1", right = "q3", height = "barwidth"
                )
            end
        )
    end

    # segments from iqr1 to q1 to and iqr2 to q3
    isnothing(segments) || push!(
        results,
        segment!(plot;
            kwargs(:Segment, segments)...,
            (if direction ≡ :vertical
                (; x0  = "key", x1 = "key", y0 = "iqr", y1 = "q")
            else
                (; y0  = "key", y1 = "key", x0 = "iqr", x1 = "q")
            end)...,
            source = Dict(
                "key" => repeat([i.key for i ∈ boxes]; inner = 2),
                "iqr" => [j for i ∈ boxes for j ∈ i.iqr],
                "q"   => [i.quantiles[j] for i ∈ boxes for j ∈ (1,3)],
            ),
        )
    )

    # positions iqr1, median, iqr2
    isnothing(borders) || let source = Dict(
            "key"      => repeat([i.key for i ∈ boxes], inner = 3),
            "position" => [j ≡ 3 ? i.quantiles[2] : i.iqr[j] for i ∈ boxes for j ∈ 1:3],
            "barwidth" => [i.barwidth * (j≡ 3 ? 1. : .5) for i ∈ boxes for j ∈ 1:3]
        )
        push!(
            results,
            if direction ≡ :vertical
                vbar!(
                    plot; kwargs(:VBar, borders)...,
                    source, x = "key", bottom = "position", top = "position", width = "barwidth"
                )
            else
                hbar!(
                    plot; kwargs(:HBar, borders)...,
                    source, y = "key", left = "position", right = "position", width = "barwidth"
                )
            end
        )
    end

    # values beyond the [iqr1, iqr2] range
    isnothing(aberrant) || push!(
        results,
        scatter!(plot;
            kwargs(:Scatter, aberrant)...,
            (direction ≡ :vertical ? (; x  = "key", y = "value") : (; y  = "value", x = "key"))...,
            source = Dict(
                "key"   => [i.key for i ∈ boxes for _ ∈ i.aberrant],
                "value" => [j     for i ∈ boxes for j ∈ i.aberrant],
            ),
        )
    )
    return results
end


"""
    boxplot(a...; k...)

Create a boxplot for every label. See `boxplot!` for arguments and keywords.
"""
function boxplot(a...; kw...)
    boxes  = boxplotitems(a...; kw...)
    kwargs = (; (k for k ∈ kw if hasfield(Models.FigureOptions, first(k)))...)
    plot   = if all(i.key isa Number for i ∈ boxes)
        figure(; kwargs...)
    else
        factors = [i.key for i ∈ boxes]
        factors isa Model.FactorSeq || (factors = string.(factors))
        if get(kw, :direction, :vertical) ≡ :vertical
            figure(; kwargs..., x_range = factors)
        else
            figure(; kwargs..., y_range = factors)
        end
    end

    boxplot!(plot, boxes; (k for k ∈ kw if !haskey(kwargs, first(k)))..., dotrigger = false)
    return plot
end

export boxplot, boxplot!
