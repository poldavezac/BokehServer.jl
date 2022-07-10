function figure(; k...)
    opts = Models.FigureOptions(;
        (i=>j for (i, j) ∈ k if hasfield(Models.FigureOptions, i))...
    )

    plot = Models.Plot()
    addaxis!(plot, opts, :x; dotrigger = false) # no need to trigger when creating a brand new plot!
    addaxis!(plot, opts, :y; dotrigger = false)
    tools!(plot, opts; dotrigger = false)
    return plot
end
export figure
