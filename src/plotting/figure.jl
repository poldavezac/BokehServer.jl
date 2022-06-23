function figure(; k...)
    opts = Models.FigureOptions(;
        (i=>j for (i, j) ∈ k if hasfield(Models.FigureOptions, i))...
    )

    plot = Models.plot()
    axis!(
        plot, true;
        type            = opts.x_axis_type,
        range           = opts.x_range,
        location        = opts.x_axis_location,
        num_minor_ticks = opts.x_minor_ticks,
        label           = opts.x_axis_label,
        dotrigger       = false # no need to trigger when creating a brand new plot!
    )
    axis!(
        plot, false;
        type            = opts.y_axis_type,
        range           = opts.y_range,
        location        = opts.y_axis_location,
        num_minor_ticks = opts.y_minor_ticks,
        label           = opts.y_axis_label,
        dotrigger       = false # no need to trigger when creating a brand new plot!
    )
    tools!(
        plot, opts.tools;
        opts.tooltips,
        opts.active_drag,
        opts.active_inspect,
        opts.active_scroll,
        opts.active_tap,
        opts.active_multi,
        dotrigger       = false # no need to trigger when creating a brand new plot!
    )
    return plot
end
