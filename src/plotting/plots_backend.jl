module BokehServerPlotsExtension
using ..AbstractTypes
import ..Model
import ..Models
import ..Plots
import ..Plotting
import ...Events

Plots.eval(:(@Plots.init_backend Bokeh)) 

using ..Plots: BokehBackend, Plot, Subplot, Series

macro font(to, from)
    to, prefix = if to isa Expr
        (to.args[1], string(to.args[2], '_'))
    else
        (to, "")
    end

    attr(x) = Symbol(replace("$(prefix)text_$x", ':' => ""))
    quote
        let fnt = $(esc(from)), ax = $(esc(to))
            ax.$(attr("font_size")) = string(
                fontsize($(esc(:plt)), fnt.pointsize), "px"
            )
            ax.$(attr("color")) = color(fnt.color)
            ax.$(attr("font")) = fnt.family
        end
    end
end

macro alpha(name)
    quote
        let a = Plots.$(Symbol("get_$(name)alpha"))($(esc(:series)), $(esc(:i)))
            isnothing(a) ? 1. : a
        end
    end
end

macro color(name)
    quote
        color(Plots.$(Symbol("get_$(name)color"))($((esc(i) for i in (:series, :clims, :i))...)))
    end
end

listattr() = Plots.merge_with_base_supported([
    :annotations,
    :legend_background_color,
    :background_color_inside,
    :background_color_outside,
    :foreground_color_grid,
    :legend_foreground_color,
    :foreground_color_title,
    :foreground_color_axis,
    :foreground_color_border,
    :foreground_color_guide,
    :foreground_color_text,
    :label,
    :linecolor,
    :linestyle,
    :linewidth,
    :linealpha,
    :markershape,
    :markercolor,
    :markersize,
    :markeralpha,
    :markerstrokewidth,
    :markerstrokecolor,
    :markerstrokealpha,
    :fillrange,
    :fillcolor,
    :fillalpha,
    :bins,
    :bar_width,
    :bar_edges,
    :bar_position,
    :title,
    :titlelocation,
    :titlefont,
    :window_title,
    :guide,
    :guide_position,
    :lims,
    :ticks,
    :scale,
    :flip,
    :rotation,
    :marker_z,
    :line_z,
    :fill_z,
    :titlefontfamily,
    :titlefontsize,
    :titlefontcolor,
    :legend_font_family,
    :legend_font_pointsize,
    :legend_font_color,
    :tickfontfamily,
    :tickfontsize,
    :tickfontcolor,
    :guidefontfamily,
    :guidefontsize,
    :guidefontcolor,
    :grid,
    :gridalpha,
    :gridstyle,
    :gridlinewidth,
    :legend_position,
    :legend_title,
    :colorbar,
    :colorbar_title,
    :colorbar_entry,
    :colorbar_ticks,
    :colorbar_tickfontfamily,
    :colorbar_tickfontsize,
    :colorbar_tickfontcolor,
    :colorbar_scale,
    :ribbon,
    :arrow,
    :orientation,
    :overwrite_figure,
    :normalize,
    :weights,
    :aspect_ratio,
    :clims,
    :stride,
    :framestyle,
    :tick_direction,
    :connections,
])
listseriestype() = (
    :path,
    :steppre,
    :stepmid,
    :steppost,
    :shape,
    :straightline,
    :scatter,
    :hexbin,
    :heatmap,
    :image,
)
liststyle() = (:auto, :solid, :dash, :dashed, :dot, :dotted, :dashdot, :dotdash)
listmarker() = Plots._allMarkers
listscale() = (:identity, :log10)

function create(plt::Plot{BokehBackend})
    Events.eventlist!(Events.NullEventList()) do
        create_plots(plt)
        create_layout(plt)
    end
    return plt.o
end

function create_plots(plt::Plot{BokehBackend})
    for sp in plt.subplots
        sp.o = Plotting.figure(;
            background_fill_color = color(sp[:background_color_inside]),
            outline_line_width = linewidth(plt, 1),
            x_axis_location = location(:x, sp),
            x_axis_type = axistype(:x, sp),
            y_axis_location = location(:y, sp),
            y_axis_type = axistype(:y, sp),
        )
    end

    for series in sort(plt.series_list; by = x->x[:series_plotindex])
        add_series(plt, series)
    end

    for sp in plt.subplots
        add_title(plt, sp)
        set_framestyle(plt, sp)
        set_axis(:x, plt, sp)
        set_axis(:y, plt, sp)
        link_axes(sp)
        set_colorbar(plt, sp)
        set_legend(plt, sp)
    end
end

function create_layout(plt::Plot{BokehBackend})
    isempty(plt.subplots) && return
    figw, figh = plt[:size]
    if length(plt.subplots) ≡ 1
        plt.o = plt.subplots[begin].o
        plt.o.width = figw
        plt.o.height = figh
        return
    end

    for sp ∈ plt.subplots
        sp.o.width = Int64(round(Plots.mm2px(Plots.width(sp.bbox).value)))
        sp.o.height = Int64(round(Plots.mm2px(Plots.height(sp.bbox).value)))
        sp.o.width_policy = :fixed
        sp.o.height_policy = :fixed
    end
    _toplot(x::Plots.GridLayout) = length(x.grid) == 1 ? x.o : _toplot.(x.grid)
    _toplot(x::Plots.Subplot) = x.o
    _toplot(x::Plots.EmptyLayout) = Models.Spacer()
    plt.o = Plotting.layout(_toplot.(plt.layout.grid))
end

function axis_kw(sp::Subplot{BokehBackend}, pos::Symbol, key::Symbol)
    sp[Plots.get_attr_symbol(pos, :axis)][key]
end

axistype(a::Symbol, sp::Subplot{BokehBackend}) = axistype(a, axis_kw(sp, a, :scale))
axistype(a::Symbol, ν::Symbol) = ν ≡ :identity ? :auto : ν ≡ :log10 ? :log : :linear

location(a::Symbol, sp::Subplot{BokehBackend}) = location(a, axis_kw(sp, a, :guide_position))
location(a::Symbol, v::Symbol) = v ≡ :top ? :above : v ≡ :auto ? (a ≡ :x ? :below : :left) : v
location(v::Symbol) = v ≡ :top ? :above : v

function link_axes(sp::Subplot{BokehBackend})
    for ax ∈ (:x, :y)
        link = sp[Symbol(ax, :axis)].sps[1].o
        if sp.o ≢ link
            rng = Symbol(ax, :range)
            left = getproperty(sp.o, rng)
            right = getproperty(link, rng)
            if left isa Models.Range1d
                setproperty!(link, rng, left)
            elseif right isa Models.Range1d
                setproperty!(sp.o, rng, right)
            else
                append!(left.renderers, right.renderers)
                setproperty!(link, rng, left)
            end
        end
    end
end

function add_series(plt::Plot{BokehBackend}, series::Series; k...)
    add_series(Val(series[:seriestype]), plt, series; k...)
    add_series(Val(:marker), plt, series; k...)
    add_fillrange(plt, series; k...)
    add_annotations(plt, series; k...)
end

function add_title(plt::Plot{BokehBackend}, sp::Subplot{BokehBackend})
    isempty(sp[:title]) && return
    rend = Plotting.Title(; text = sp[:title])
    @font rend Plots.titlefont(sp)
    
    push!(
        getproperty(
            sp.o,
            sp[:titlelocation] ∈ (:left, :right, :bottom) ? sp[:titlelocation] : :above
        ),
        rend
    )
    return rend
end

function set_framestyle(plt::Plot{BokehBackend}, sp::Subplot{BokehBackend})
    if sp[:framestyle] ≡ :box
        sp.o.outline_line_alpha = 1.
        sp.o.outline_line_color = "#000000"
    elseif sp[:framestyle] ≡ :semi
        sp.o.outline_line_alpha = 0.2
        sp.o.outline_line_color = "#000000"
    elseif sp[:framestyle] ≡ :origin
        sp.o.outline_line_alpha = 0.
        for pos ∈ (:x, :y), ax ∈ Plotting.getaxis(sp.o, pos).axes
            ax.fixed_location = 0.0
        end
    elseif sp[:framestyle] ≡ :zerolines
        sp.o.outline_line_alpha = 0.
        for pos ∈ (:x, :y), ax ∈ Plotting.getaxis(sp.o, pos).axes
            ax.axis_line_alpha = 0.0
        end
        push!(
            sp.o.center,
            (
                Plotting.Span(;
                    dimension,
                    location = 0.,
                    line_color = color(sp[:xaxis][:foreground_color_axis]),
                    line_width = linewidth(plt, 0.75),
                )
                for dimension ∈ (:width, :height)
            )...
        )
    elseif sp[:framestyle] ≡ :grid
        sp.o.outline_line_alpha = 0.
        for pos ∈ (:x, :y), ax ∈ Plotting.getaxis(sp.o, pos).axes
            ax.axis_line_alpha = 0.0
        end
    elseif sp[:framestyle] ≡ :none
        sp.o.outline_line_alpha = 0.
        for pos ∈ (:x, :y)
            axinfo = Plotting.getaxis(sp.o, pos)
            for itm ∈ Iterators.flatten((axinfo.grids, axinfo.axes))
                itm.visible = false
            end
        end
    end
end

function is_factor_range(sp, pos::Symbol)
    axissym = Plots.get_attr_symbol(pos, :axis)
    axis = sp[axissym]
    return (
        !isempty(axis[:discrete_values])
        && all(i isa AbstractString for i in axis[:discrete_values])
    )
end


function set_axis(pos::Symbol, plt::Plot{BokehBackend}, sp::Subplot{BokehBackend})
    axinfo = Plotting.getaxis(sp.o, pos)
    axissym = Plots.get_attr_symbol(pos, :axis)
    axis = sp[axissym]

    lfrom, lto = Plots.axis_limits(sp, pos)
    isfinite(lfrom) && (axinfo.range.start = lfrom)
    isfinite(lto) && (axinfo.range.finish = lto)
    if get(axis.plotattributes, :flip, false)
        if axinfo.range isa Models.DataRange1d
            axinfo.range.flipped = true
        else
            tmp = axinfo.range.finish
            axinfo.range.finish =  axinfo.range.start
            axinfo.range.finish = tmp
        end
    end

    if is_factor_range(sp, pos)
        rng = Models.FactorRange(; factors = collect(axis[:discrete_values]))
        Plotting.resetaxis!(
            sp.o,
            Plotting.createaxis(pos; range = rng)
        )
    elseif axis[:ticks] isa AbstractVector
        for ax ∈ axinfo.axes
            ax.ticker = Models.FixedTicker(ticks = axis[:ticks])
        end
    end

    for ax ∈ axinfo.axes
        @font ax.major_label Plots.tickfont(axis)
        @font ax.axis_label Plots.guidefont(axis)
        ax.axis_line_color = color(axis[:foreground_color_axis])
        ax.visible = !isnothing(axis[:ticks]) && axis[:showaxis] && sp[:framestyle] ≢ :none
    end

    for grid ∈ axinfo.grids
        grid.grid_line_color = color(axis[:foreground_color_grid])
        grid.grid_line_alpha = axis[:gridalpha]
        grid.grid_line_width = linewidth(plt, axis[:gridlinewidth])
        grid.grid_line_dash = linestyle(axis[:gridstyle])

        if axis[:minorgrid]
            grid.minor_grid_line_color = color(axis[:foreground_color_grid])
            grid.minor_grid_line_alpha = axis[:minorgridalpha]
            grid.minor_grid_line_width = linewidth(plt, axis[:minorgridlinewidth])
            grid.minor_grid_line_dash = linestyle(axis[:minorgridstyle])
        end
    end
end

function set_legend(plt::Plot{BokehBackend}, sp::Subplot{BokehBackend})
    if sp[:legend_position] ≡ :none
        Model.models(sp.o) do leg
            (leg isa Models.iLegend) && (leg.visible = false)
        end
        return
    end
        
    Model.models(sp.o) do leg
        if leg isa Models.iLegend
            leg.location = let x = sp[:legend_position]
                x ≡ :best ? :top_right : :x
            end

            @font leg.label Plots.legendfont(sp)

            leg.background_fill_color = color(sp[:legend_background_color])
            leg.border_line_color = color(sp[:legend_foreground_color])
            leg.border_line_width = linewidth(plt, 1)

            leg.title = sp[:legend_title]
            @font leg.title Plots.legendtitlefont(sp)
        end
    end
end

function set_colorbar(plt, sp::Subplot{BokehBackend})
    Plots.hascolorbar(sp) || return

    # add keyword args for a discrete colorbar
    slist = Plots.series_list(sp)
    colorbar_series = slist[findfirst(Plots.hascolorbar.(slist))]

    cmap = find_lincmap(sp)
    isnothing(cmap) && return

    ticker, formatter = if !isempty(sp[:zaxis][:discrete_values]) && colorbar_series[:seriestype] === :heatmap
        (
            FixedTicker(ticks = sp[:zaxis][:discrete_values]),
            NumeralTickFormatter()
        )
    else
        :auto, :auto
    end

    loc = location(sp[:colorbar])
    (loc ≡ :best) && (loc = :right)
    cbar = Models.ColorBar(;
        ticker, formatter,
        color_mapper = cmap,
        orientation = loc ∈ (:left, :right) ? :vertical : :horizontal,
        title = sp[:colorbar_title],
        major_tick_line_width = linewidth(plt, 1),
    )
    @font cbar.title Plots.colorbartitlefont(sp)
    @font cbar.major_label Plots.font(;
        family = sp[:colorbar_tickfontfamily],
        pointsize = sp[:colorbar_tickfontsize],
        color = sp[:colorbar_tickfontcolor],
    )

    push!(getproperty(sp.o, loc), cbar)
    return cbar
end

function _line_info(plt, series, rng, i)
    clims = Plots.get_clims(series[:subplot], series)
    (;
        x          = view(series[:x], rng),
        y          = view(series[:y], rng),
        line_color = color(Plots.single_color(Plots.get_linecolor(series, clims, i)), @alpha(line)),
        line_width = linewidth(plt, series, i),
        line_dash  = linestyle(series, i),
    )
end

function add_series(::Val{:straightline}, plt::Plot{BokehBackend}, series::Series)
    clims = Plots.get_clims(series[:subplot], series)
    for segment in Plots.series_segments(series, series[:seriestype]; check = true)
        i, rng = segment.attr_index, segment.range
        isempty(rng) && continue

        x  = view(series[:x], rng)
        y  = view(series[:y], rng)
        vals = (;
            line_color = color(Plots.single_color(Plots.get_linecolor(series, clims)), @alpha(line)),
            line_width = linewidth(plt, series, i),
            line_dash  = linestyle(series, i),
            legend_label= series[:label],
        )
        if length(x) ≡ 2 && x[1] == 1 && x[2] == 2 && y[1] == y[2]
            vals = merge(vals, (; dimension = :width, location = y[1]))
        elseif length(y) ≡ 2 && y[1] == 1 && y[2] == 2 && x[1] == x[1]
            vals = merge(vals, (; dimension = :height, location = x[1]))
        else
            Plotting.ray!(series[:subplot].o;
                pairs(vals)...,
                angle = let dx = last(vals.x) - first(vals.x)
                    dy = last(vals.y) - first(vals.y)
                    acos(dx/√(dx^2 + dy^2))
                end
            )
            continue
        end

        push!(
            series[:subplot].o.center,
            Models.Span(; pairs(vals)...)
        )
    end
end

for 𝑇 ∈ (:stepmid, :steppost, :steppre, :path)
    @eval function add_series(𝑇::$(Val{𝑇}), plt::Plot{BokehBackend}, series::Series)
        clims = Plots.get_clims(series[:subplot], series)
        mode = (; mode = $(Meta.quot(𝑇 ≡ :steppost ? :after : 𝑇 ≡ :stepmid ? :center : :before)))
        for segment in Plots.series_segments(series, series[:seriestype]; check = true)
            i, rng = segment.attr_index, segment.range
            isempty(rng) && continue
            vals = _line_info(plt, series, rng, i)
            $(𝑇 ≢ :path ? :(vals = merge(vals, mode)) : nothing)
            $(𝑇 ≡ :path ? Plotting.line! : Plotting.step!)(
                series[:subplot].o; legend_label=series[:label], pairs(vals)...
            )
        end
        add_arrows(plt, series)
    end
end

function add_arrows(plt::Plot{BokehBackend}, series::Series)
    (series[:seriestype] ∉ (:path, :steppre, :stepmid, :steppost, :straightline)) || return
    (maximum(series[:linewidth]) > 0) || return
    (series[:arrow] isa Arrow) || return

    push!(
        series[:subplot].o.center,
        Plotting.Arrow(
            legend_label= series[:label],
            line_color = color(Plots.get_linecolor(series)),
            line_width = linewidth(plt, series),
            line_dash = linestyle(series),
            x_start = series[:x][1:end-1],
            x_end = series[:x][2:end],
            y_start = series[:y][1:end-1],
            y_end = series[:y][2:end],
            finish = OpenHead(
                line_color = color(Plots.get_linecolor(series)),
                line_width = series[:arrow].headwidth,
                line_dash = linestyle(series),
                size       = series[:arrow].headlength,
            )
        )
    )
end

add_series(::Val{:none}, _...) = nothing

add_series(::Val{:scatter}, plt::Plot{BokehBackend}, series::Series) = nothing

function add_series(::Val{:marker}, plt::Plot{BokehBackend}, series::Series)
    (series[:markershape] ≡ :none) && return
    (series[:seriestype] ∈ (
            :path, :scatter, :path3d, :scatter3d, :steppre, :stepmid, :steppost, :bar
    )) || return

    return add_segments(Plotting.scatter!, plt, series, :scatter) do i, rng
        (;
            x           = view(series[:x], rng),
            y           = view(series[:y], rng),
            marker      = getmarker(Plots._cycle(series[:markershape], i)),
            size        = markerwidth(plt, Plots._cycle(series[:markersize], i)),
            hatch_color = color(Plots.get_markercolor(series, i)),
            hatch_alpha = Plots.get_markeralpha(series, i),
            line_color  = color(Plots.get_markerstrokecolor(series, i)),
            line_alpha  = Plots.get_markerstrokealpha(series, i),
            line_width  = linewidth(plt, Plots.get_markerstrokewidth(series, i)),
        )
    end
end

function add_series(::Val{:hexbin}, plt::Plot{BokehBackend}, series::Series)
    oks = isfinite.(series[:x]) .&& isfinite.(series[:y])
    xv = series[:x][oks]
    yv = series[:y][oks]
    bins = series[:bins] === :auto ? 100 : series[:bins]
    sizex = (maximum(xv) - minimum(xv)) / bins
    sizey = (maximum(xv) - minimum(xv)) / bins

    rend = Plotting.hexbin!(
        series[:subplot].o,
        xv,
        yv,
        sizex;
        legend_label= series[:label],
        weights      = series[:weights],
        mincount     = get(series[:extra_kwargs], :mincnt, nothing),
        fill_alpha   = isnothing(series[:fillalpha]) ? 1. : series[:fillalpha],
        line_width   = linewidth(plt, series[:linewidth]),
        aspect_scale = sizex/sizey,
    )
    rend.glyph.fill_color = (;
        field = "c",
        transform = find_lincmap(series[:subplot], series, rend.data_source.data["c"]),
    )
    return rend
end

function add_series(::Val{:heatmap}, plt::Plot{BokehBackend}, series::Series)
    sp   = series[:subplot]

    x = is_factor_range(sp, :x) ? series[:x] .+ .5 : series[:x]
    y = is_factor_range(sp, :y) ? series[:y] .+ .5 : series[:y]

    x, y = Plots.heatmap_edges(
        x, sp[:xaxis][:scale], y, sp[:yaxis][:scale], size(series[:z])
    )
    z = series[:z].surf
    width = sum(x[2:end] .- x[1:end-1]) / length(x)
    height = sum(y[2:end] .- y[1:end-1]) / length(y)

    source = Models.Source(
        "x" => repeat(x[1:end-1]; inner=size(z, 2)),
        "y" => repeat(y[1:end-1]; outer=size(z, 1)),
        "z" => reshape(z, :),
    )

    z = reshape(z, :)

    fill_color = (; field = "z", transform = find_lincmap(sp, series, z))
    Plotting.rect!(
        sp.o;
        x = "x", y = "y",
        source, width, height,
        legend_label= series[:label],
        fill_alpha = isnothing(series[:fillalpha]) ? 1 : series[:fillalpha],
        fill_color,
        line_color = fill_color,
        line_width = linewidth(plt, series),
    )
end

function add_series(::Val{:image}, plt::Plot{BokehBackend}, series::Series)
    xmin, xmax = ignorenan_extrema(series[:x])
    ymin, ymax = ignorenan_extrema(series[:y])
    dx = (xmax - xmin) / (length(series[:x]) - 1) / 2
    dy = (ymax - ymin) / (length(series[:y]) - 1) / 2
    if eltype(z) <: Colors.AbstractGray
        f = Plotting.image!
        z = float(z)
    elseif eltype(z) <: Colorant
        f = Plotting.imagergba!
        z = map(c -> Float64[red(c), green(c), blue(c), alpha(c)], z)
    else
        raise(ErrorException("Not implemented"))
    end

    return f(
        series[:subplot].o;
        image = [z],
        x = xmin, y = ymin,
        dw = xmax-xmin,
        dh = ymax-ymin,
    )
end

function add_series(::Val{:contour}, plt::Plot{BokehBackend}, series::Series)
end

function add_series(::Val{:surf}, plt::Plot{BokehBackend}, series::Series)
end

function add_series_(::Val{:shape}, plt::Plot{BokehBackend}, series::Series)
    clims = Plots.get_clims(series[:subplot], series)
    for segment in Plots.series_segments(series)
        i, rng = segment.attr_index, segment.range
        isempty(rng) && continue
        ls = linestyle(series, i)
        patt = fillstyle(series, i)
        isnothing(line_alpha) && (line_alpha = 1.)
        Plotting.vbar!(series[:subplot].o;
            x = view(series[:x], rng),
            top = view(series[:y], rng),
            legend_label= series[:label],
            line_color = @color(line),
            fill_color = @color(fill),
            fill_alpha = @alpha(fill),
            line_alpha = @alpha(line),
            line_dash  = ls,
            hatch_style = ls,
            hatch_pattern = patt,
            hatch_alpha  = if patt isa AbstractVector
                [i ≡ :blank ? 0.f0 : 1.f0 for i ∈ patt]
            else
                patt ≡ :blank ? 0.f0 : 1.f0
            end
        )
    end
end

function add_series(::Val{:shape}, plt::Plot{BokehBackend}, series::Series)
    clims = Plots.get_clims(series[:subplot], series)
    return add_segments(Plotting.vbar!, plt, series, :scatter) do i, rng
        hatch_pattern = fillstyle(series, i)
        (;
            line_dash = linestyle(series, i),
            hatch_alpha = hatch_pattern ≡ :blank ? 0.f0 : 1.f0,
            fill_alpha = @alpha(fill),
            line_alpha = @alpha(line),
            line_color = @color(line),
            fill_color = @color(fill),
            x = let v = view(series[:x], rng)
                (maximum(v) + minimum(v)) * .5f0
            end,
            bottom = minimum(view(series[:y], rng)),
            top = maximum(view(series[:y], rng)),
            width = let v = view(series[:x], rng)
                (maximum(v) - minimum(v))
            end,
        )
    end
end

function add_segments(𝐹::Function, plotfunc, plt, series, args...; kwargs...)
    type = (;
        fill_color = String, hatch_color = String,  line_color  = String,
        marker = Symbol, hatch_pattern = Symbol,
    )

    items = Dict{Symbol, Any}()
    for segment in Plots.series_segments(series, args...; kwargs...)
        i, rng = segment.attr_index, segment.range
        isempty(rng) && continue
        values = (; (i for i in pairs(𝐹(i, rng)) if !isnothing(i[2]))...)
        if (
            !isempty(items)
            && (
                any(i ∉ keys(items) for i in keys(values))
                || !any(i ∉ keys(values) for i in items)
                || get(items, :line_dash, nothing) ≢ get(values, :line_dash, nothing)
            )
        )
            plotfunc(series[:subplot].o; legend_label = series[:label], items...)
            empty!(items)
        end

        for (i, j) ∈ pairs(values)
            if i ≡ :line_dash
                items[i] = j
                continue
            end

            if !haskey(items, i)
                items[i] = get(type, i, Float32)[]
            end
            append!(items[i], j isa AbstractVector ? j : (j for _ ∈ rng))
        end
    end
    isempty(items) || plotfunc(series[:subplot].o; legend_label = series[:label], items...)
end

function add_fillrange(plt::Plot{BokehBackend}, series::Series)
    fillrange = series[:fillrange]
    (isnothing(fillrange) || series[:seriestype] ≡ :contour) && return

    clims = Plots.get_clims(series[:subplot], series)
    for segment in Plots.series_segments(series)
        i, rng = segment.attr_index, segment.range
        args = if typeof(fillrange) <: Union{Real,AbstractVector} && Plots.isvertical(series)
            view(series[:x], rng), Plots._cycle(fillrange, rng), view(series[:y], rng)
        elseif typeof(fillrange) <: Union{Real,AbstractVector}
            Plots._cycle(fillrange, rng), view(series[:x], rng), view(series[:y], rng)
        elseif is_2tuple(fillrange) && Plots.isvertical(series)
            view(series[:x], rng), Plots._cycle(fillrange[1], rng), Plots._cycle(fillrange[2], rng)
        else
            Plots._cycle(fillrange[1], rng), Plots._cycle(fillrange[2], rng), view(series[:y], rng)
        end

        fill_alpha = @alpha(fill)
        fs = fillstyle(series, i)
        (Plots.isvertical(series) ? Plotting.harea! : Plotting.varea!)(
            series[:subplot].o, args...;
            legend_label= series[:label],
            line_alpha = @alpha(line),
            line_color = @color(line),
            fill_alpha,
            fill_color = @color(fill),
            hatch_color = @color(fill),
            hatch_alpha = isnothing(fs) ? 0. : fill_alpha,
            hatch_pattern = fs,
        )
    end
end

function add_annotations(plt::Plot{BokehBackend}, series::Series)
    anns = series[:series_annotations]
    (isnothing(anns) || isempty(anns)) && return
    x = Float32[]
    y = Float32[]
    text = String[]
    text_color = String[]
    text_font = String[]
    text_font_size = String[]
    angle = Float32[]
    for (xi, yi, str, fnt) in Plots.EachAnn(anns, series[:x], series[:y])
        push!(x, xi)
        push!(y, yi)
        push!(text, str)
        push!(angle, fnt.rotation),
        push!(text_font, Symbol(fnt.family))
        push!(text_font_size, "$(fnt.size)px")
        push!(text_color, color(fnt.color))
    end

    Plotting.text!(
        series[:subplot].o;
        x, y, text, text_color, text_font_size, text_font, angle,
    )
end

function find_lincmap(sp::Subplot{BokehBackend})
    arr = Array{Any, 0}(nothing)
    Model.models(sp.o) do x
        if x isa Models.LinearColorMapper
            arr[] = x
            true
        else
            false
        end
    end
    return arr[]
end

function find_lincmap(sp::Subplot{BokehBackend}, series::Series, vals::AbstractVector)
    oks = [i for i in vals if isfinite(i)]
    cmap = find_lincmap(sp)
    isempty(oks) && return cmap

    clims = collect(Plots.get_clims(sp, series))
    clims[1] = min(minimum(oks), isfinite(clims[1]) ? clims[1] : Inf32)
    clims[2] = max(maximum(oks), isfinite(clims[2]) ? clims[2] : -Inf32)

    if isnothing(cmap)
        cmap = Models.LinearColorMapper(color.(series[:fillcolor].colors), clims...)
    else
        cmap.low = min(cmap.low, clims[1])
        cmap.high = max(cmap.high, clims[1])
    end
    return cmap
end

fillstyle(value::Union{Symbol, Nothing}) = isnothing(value) ? :blank : val
fillstyle(value::Union{Symbol, Nothing}) = isnothing(value) ? :blank : val
getmarker(marker) = marker
function markerwidth(plt::Plot{BokehBackend}, x...)
    val = linewidth(plt, x...)
    return val isa AbstractVector ? val .^ 2 : val ^ 2
end

for 𝐹 ∈ (:fontsize, :linewidth)
    @eval function $𝐹(plt::Plot{BokehBackend}, x)
        f = plt[:thickness_scaling]
        x isa AbstractVector ? x .* f : x * f
    end
end

function linestyle(ls::Symbol)
    ls === :dot && return :dotted
    ls === :dashdot && return :dotdash
    ls === :dash && return :dashed
    return ls
end
linestyle(s::Series) = linestyle(s[:linestyle], Plots.get_linestyle(s))

linewidth(plt::Plot{BokehBackend}, s::Series, i...) = linewidth(plt, Plots.get_linewidth(s, i...))

for 𝐹 ∈ (:fillstyle, :linestyle)
    @eval $𝐹(s::Plots.Series, i::Int64) = $𝐹(Plots.$(Symbol("get_$𝐹"))(s, i))
    @eval $𝐹(s::Plots.Series, x::AbstractVector) = [$𝐹(s, i) for i ∈ x]
end

color(s) = color(parse(Plots.PlotUtils.Colorant, string(s)))
color(c::Plots.PlotUtils.Colorant) = Model.colorhex(c)
color(cs::AbstractVector) = map(color, cs)
color(grad::Plots.PlotUtils.AbstractColorList) = color(Plots.PlotUtils.color_list(grad))
color(c::Plots.PlotUtils.Colorant, α) = color(Plots.PlotUtils.plot_color(c, α))

function Plots._initialize_backend(pkg::BokehBackend)
    @eval Main begin
        import BokehServer
        export BokehServer
    end
end

for s in (:attr, :seriestype, :marker, :style, :scale)
    v = Symbol("list", s)
    @eval begin
        Plots.$(Symbol("is_", s, "_supported"))(::BokehBackend, $s::Symbol) = $s in $v()
        Plots.$(Symbol("supported_", s, "s"))(::BokehBackend) = sort(collect($v()))
    end
end

# Write a png to io.  You could define methods for:
    # "application/eps"         => "eps",
    # "image/eps"               => "eps",
    # "application/pdf"         => "pdf",
    # "image/png"               => "png",
    # "application/postscript"  => "ps",
    # "image/svg+xml"           => "svg"
function Plots._show(io::IO, ::MIME"text/html", plt::Plot{BokehBackend})
    return write(io, Plotting.html(()-> create(plt); browser = false).content)
end

# Display/show the plot (open a GUI window, or browser page, for example).
Plots._display(plt::Plot{BokehBackend}) = Plotting.html(()-> create(plt))

Plotting.figure(plt::Plot{BokehBackend}) = create(plt)
end
