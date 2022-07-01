function figure(; k...)
    opts = Models.FigureOptions(;
        (i=>j for (i, j) ∈ k if hasfield(Models.FigureOptions, i))...
    )

    plot = Models.Plot()
    addaxis!(
        plot, true;
        type            = opts.x_axis_type.value,
        range           = opts.x_range,
        location        = opts.x_axis_location.value,
        num_minor_ticks = opts.x_minor_ticks == :auto ? missing : opts.x_minor_ticks,
        label           = opts.x_axis_label,
        dotrigger       = false # no need to trigger when creating a brand new plot!
    )
    addaxis!(
        plot, false;
        type            = opts.y_axis_type.value,
        range           = opts.y_range,
        location        = opts.y_axis_location.value,
        num_minor_ticks = opts.y_minor_ticks == :auto ? missing : opts.y_minor_ticks,
        label           = opts.y_axis_label,
        dotrigger       = false # no need to trigger when creating a brand new plot!
    )
    tools!(
        plot, opts.tools;
        tooltips       = something(opts.tooltips, missing),
        active_drag    = opts.active_drag isa Model.EnumType ? opts.active_drag.value : opts.active_drag,
        active_inspect = opts.active_inspect isa Model.EnumType ? opts.active_inspect.value : opts.active_inspect,
        active_scroll  = opts.active_scroll isa Model.EnumType ? opts.active_scroll.value : opts.active_scroll,
        active_tap     = opts.active_tap isa Model.EnumType ? opts.active_tap.value : opts.active_tap,
        active_multi   = opts.active_multi isa Model.EnumType ? opts.active_multi.value : opts.active_multi,
        dotrigger      = false # no need to trigger when creating a brand new plot!
    )
    return plot
end

"""
    layout(obj::AbstractArray{<:Models.iLayoutDOM, 2})
    layout(obj::AbstractVector{<:Models.iLayoutDOM})

create a layout
"""
function layout(children::AbstractVector{<:Models.iLayoutDOM})
    return if isempty(children)
        nothing
    elseif length(children) ≡ 1
        children[1]
    else
        Models.Row(; children = collect(Models.iLayoutDOM, children))
    end
end

function layout(children::AbstractArray{<:Models.iLayoutDOM, 2})
    return if isempty(children)
        nothing
    elseif length(children) ≡ 1
        children[1]
    elseif size(x, 1) ≡ 1
        Models.Row(; children = collect(Models.iLayoutDOM, children))
    elseif size(x, 2) ≡ 1
        Models.Column(; children = collect(Models.iLayoutDOM, children))
    else
        Models.Row(; children = [layout(@view children[i,:]) for i ∈ axes(x,1)])
    end
end
