#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
push!(LOAD_PATH, joinpath(@__DIR__, "environment"))
using BokehJL
using Random
using StatsBase

# create three normal population samples with different parameters
x1 = (Random.randn(400) .+ 5.0) .* 100 
y1 = (Random.randn(400) .+ 10.0) .* 10 

x2 = (Random.randn(800) .+ 5.0) .* 50 
y2 = (Random.randn(800) .+ 5.0) .* 10 

x3 = (Random.randn(200) .+ 55.0) .* 10 
y3 = (Random.randn(200) .+ 4.0) .* 10 

x = [x1..., x2..., x3...]
y = [y1..., y2..., y3...]

TOOLS="pan,wheel_zoom,box_select,lasso_select,reset"

BokehJL.Plotting.serve() do
    # create the scatter plot
    p = BokehJL.figure(tools=TOOLS, width=600, height=600, min_border=10, min_border_left=50,
               toolbar_location="above", x_axis_location=nothing, y_axis_location=nothing,
               title="Linked Histograms")
    p.background_fill_color = "#fafafa"
    only(BokehJL.Model.filtermodels(BokehJL.BoxSelectTool, p)).select_every_mousemove = false
    only(BokehJL.Model.filtermodels(BokehJL.LassoSelectTool, p)).select_every_mousemove = false

    r = BokehJL.scatter!(p; x, y, size=3, color="#3A5785", alpha=0.6)
    LINE_ARGS = (; color="#3A5785", line_color= "#00000000")

    # create the horizontal histogram
    hhist, hedges = let val = fit(Histogram, x; nbins = 20)
        (val.weights, val.edges[1])
    end
    hzeros = zeros(Int32,length(hedges)-1)
    hmax = maximum(hhist)*1.1

    ph = BokehJL.figure(toolbar_location=nothing, width=p.width, height=200, x_range=p.x_range,
                y_range=(-hmax, hmax), min_border=10, min_border_left=50, y_axis_location="right")
    ph.xgrid.grid_line_color = "#00000000"
    ph.yaxis.major_label_orientation = π/4
    ph.background_fill_color = "#fafafa"
    BokehJL.quad!(ph; bottom=0, left=hedges[1:end-1], right=hedges[2:end], top=hhist, color="white", line_color="#3A5785")
    hh1 = BokehJL.quad!(ph; bottom=0, left=hedges[1:end-1], right=hedges[2:end], top=hzeros, alpha=0.5, LINE_ARGS...)
    hh2 = BokehJL.quad!(ph; bottom=0, left=hedges[1:end-1], right=hedges[2:end], top=hzeros, alpha=0.1, LINE_ARGS...)

    # create the vertical histogram
    vhist, vedges = let val = fit(Histogram, y; nbins = 20)
        (val.weights, val.edges[1])
    end
    vzeros = zeros(Int32,length(vedges)-1)
    vmax = maximum(vhist)*1.1

    pv = BokehJL.figure(toolbar_location=nothing, width=200, height=p.height, x_range=(-vmax, vmax),
                y_range=p.y_range, min_border=10, y_axis_location="right")
    pv.ygrid.grid_line_color = "#00000000"
    pv.xaxis.major_label_orientation = π/4
    pv.background_fill_color = "#fafafa"

    BokehJL.quad!(pv; left=0, bottom=vedges[1:end-1], top=vedges[2:end], right=vhist, color="white", line_color="#3A5785")
    vh1 = BokehJL.quad!(pv; left=0, bottom=vedges[1:end-1], top=vedges[2:end], right=vzeros, alpha=0.5, LINE_ARGS...)
    vh2 = BokehJL.quad!(pv; left=0, bottom=vedges[1:end-1], top=vedges[2:end], right=vzeros, alpha=0.1, LINE_ARGS...)

    BokehJL.onchange(r.data_source.selected) do evt::BokehJL.ModelChangedEvent
        if evt.attr ≡ :indices
            inds = evt.new
            if isempty(inds) || length(inds) ≡ length(x)
                hhist1, hhist2 = hzeros, hzeros
                vhist1, vhist2 = vzeros, vzeros
            else
                neg_inds = ones(Bool, size(x))
                for i ∈ inds
                    neg_inds[i] = false
                end
                uw1 = uweights(length(inds))
                uw2 = uweights(length(x)-length(inds))
                hhist1 = fit(Histogram, x[inds], uw1, hedges).weights
                vhist1 = fit(Histogram, y[inds], uw1, vedges).weights
                hhist2 = fit(Histogram, x[neg_inds], uw2, hedges).weights
                vhist2 = fit(Histogram, y[neg_inds], uw2, vedges).weights
            end

            hh1.data_source.data["top"]   =  hhist1
            hh2.data_source.data["top"]   = -hhist2
            vh1.data_source.data["right"] =  vhist1
            vh2.data_source.data["right"] = -vhist2
        end
    end

    BokehJL.layout([p pv; ph nothing]; toolbar_location = nothing)
end
