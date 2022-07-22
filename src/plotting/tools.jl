module ToolsPlotting
using ...AbstractTypes
using ...Model
using ...Models

function defaulttool(σ::Symbol)
    (σ ≡ :pan)           && return Models.PanTool(dimensions=:both)
    (σ ≡ :xpan)          && return Models.PanTool(dimensions=:width)
    (σ ≡ :ypan)          && return Models.PanTool(dimensions=:height)
    (σ ≡ :xwheel_pan)    && return Models.WheelPanTool(dimension=:width)
    (σ ≡ :ywheel_pan)    && return Models.WheelPanTool(dimension=:height)
    (σ ≡ :wheel_zoom)    && return Models.WheelZoomTool(dimensions=:both)
    (σ ≡ :xwheel_zoom)   && return Models.WheelZoomTool(dimensions=:width)
    (σ ≡ :ywheel_zoom)   && return Models.WheelZoomTool(dimensions=:height)
    (σ ≡ :zoom_in)       && return Models.ZoomInTool(dimensions=:both)
    (σ ≡ :xzoom_in)      && return Models.ZoomInTool(dimensions=:width)
    (σ ≡ :yzoom_in)      && return Models.ZoomInTool(dimensions=:height)
    (σ ≡ :zoom_out)      && return Models.ZoomOutTool(dimensions=:both)
    (σ ≡ :xzoom_out)     && return Models.ZoomOutTool(dimensions=:width)
    (σ ≡ :yzoom_out)     && return Models.ZoomOutTool(dimensions=:height)
    (σ ≡ :click)         && return Models.TapTool(behavior=:inspect)
    (σ ≡ :tap)           && return Models.TapTool()
    (σ ≡ :doubletap)     && return Models.TapTool(gesture=:doubletap)
    (σ ≡ :crosshair)     && return Models.CrosshairTool()
    (σ ≡ :box_select)    && return Models.BoxSelectTool()
    (σ ≡ :xbox_select)   && return Models.BoxSelectTool(dimensions=:width)
    (σ ≡ :ybox_select)   && return Models.BoxSelectTool(dimensions=:height)
    (σ ≡ :poly_select)   && return Models.PolySelectTool()
    (σ ≡ :lasso_select)  && return Models.LassoSelectTool()
    (σ ≡ :box_zoom)      && return Models.BoxZoomTool(dimensions=:both)
    (σ ≡ :xbox_zoom)     && return Models.BoxZoomTool(dimensions=:width)
    (σ ≡ :ybox_zoom)     && return Models.BoxZoomTool(dimensions=:height)
    (σ ≡ :save)          && return Models.SaveTool()
    (σ ≡ :undo)          && return Models.UndoTool()
    (σ ≡ :redo)          && return Models.RedoTool()
    (σ ≡ :reset)         && return Models.ResetTool()
    (σ ≡ :help)          && return Models.HelpTool()
    (σ ≡ :box_edit)      && return Models.BoxEditTool()
    (σ ≡ :line_edit)     && return Models.LineEditTool()
    (σ ≡ :point_draw)    && return Models.PointDrawTool()
    (σ ≡ :poly_draw)     && return Models.PolyDrawTool()
    (σ ≡ :poly_edit)     && return Models.PolyEditTool()
    (σ ≡ :freehand_draw) && return Models.FreehandDrawTool()
    (σ ≡ :hover)         && return Models.HoverTool(tooltips=[
        ("index",         "\$index"),
        ("data (x, y)",   "(\$x, \$y)"),
        ("screen (x, y)", "(\$sx, \$sy)"),
    ])
    throw(ErrorException("Unknown tool shorthand $σ"))
end
defaulttool(x::Models.iTool) = x
defaulttool(x::AbstractString) = defaulttool(Symbol(strip(x)))

Model.bokehconvert(::Type{Models.iTool}, x::Union{Models.iTool, AbstractString, Symbol, Val}) = defaulttool(x)

_toollist(t::AbstractString) = _toollist(split(t, ','))
function _toollist(
    tools :: AbstractVector{<:Union{Symbol, AbstractString, Models.iTool}},
)
    lst = [defaulttool.(i) for i ∈ tools]
    keeps = let keeps = ones(Bool, length(lst))

        _isdiff(_...)                 = true
        _isdiff(x::T, y::T) where {T} = !Model.compare(x, y)
        _isdiff(x::T, y::T) where {T <: iHasProps} = any(
            _isdiff(getproperty(x, k), getproperty(y, k))
            for k ∈ propertynames(lst[i])
            if k ≢ :id
        )

        for i ∈ 1:length(lst)-1
            keeps[i] && for j ∈ (i+1) : length(lst)
                keeps[j] = keeps[j] && _isdiff(lst[i], lst[j])
            end
        end
        keeps
    end

    _arg(x::Union{Models.iTool, Symbol}) = x
    _arg(x::AbstractString)              = Symbol(strip(x))

    return Any[
        (; tool, arg = _arg(arg), keep)
        for (tool, arg, keep) ∈ zip(lst, tools, keeps)
    ]
end

_tooltips!(::Vector, ::Missing, ::Bool) = nothing
function _tooltips!(lst::Vector, tooltips, dotrigger :: Bool)
    found = false
    for (i, tool) ∈ enumerate(lst)
        if tool.keep && tool.tool isa Models.HoverTool
            found = true
            setproperty!(
                tool.tool,
                :tooltips,
                tooltips;
                dotrigger = dotrigger && tool.arg isa Models.iTool
            )
        end
    end

    if !found
        push!(lst, (; tool = Models.HoverTool(; tooltips), arg = :hover, keep = true))
        push!(keep, true)
    end
end

function _active!(tb::Models.iToolbar, val::Union{Nothing, Models.iTool}, attr::Symbol, dotrigger::Bool, ::Vector)
    setproperty!(tb, attr, val; dotrigger)
end

function _active!(tb::Models.iToolbar, val::AbstractString, attr::Symbol, dotrigger::Bool, lst::Vector)
    _active!(tb, Symbol(strip(val)), attr, dotrigger, lst)
end

function _active!(tb::Models.iToolbar, val::Symbol, attr::Symbol, dotrigger::Bool, lst::Vector)
    if val ≡ :auto
        setproperty!(tb, attr, :auto; dotrigger)
    else
        for i ∈ lst 
            if i.arg ≡ val
                setproperty!(tb, attr, i.tool; dotrigger)
                break
            end
        end
        throw(ErrorException("Could not find tool `$val` to activate"))
    end
end

const ActiveArg = Union{AbstractString, Symbol, Nothing, T} where {T <: Models.iTool}

"""
    tools!(
            fig            :: Models.Plot,
            tools          :: Union{AbstractString, Vector{Union{Symbol, AbstractString, Models.iTool}}},
            tooltips       :: Union{Missing, AbstractString, AbstractVector}       = missing;
            active_drag    :: Union{AbstractString, Symbol, Nothing, iDrag}        = :auto,
            active_inspect :: Union{AbstractString, Symbol, Nothing, iInspectTool} = :auto,
            active_scroll  :: Union{AbstractString, Symbol, Nothing, iScoll}       = :auto,
            active_tap     :: Union{AbstractString, Symbol, Nothing, iGestureTool} = :auto,
            active_multi   :: Union{AbstractString, Symbol, Nothing, iGestureTool} = :auto,
            dotrigger      :: Bool                                                 = true
    )

Adds *more* tools to the plot.

Arguments

* active_drag (str, None, "auto" or Tool): the tool to set active for drag
* active_inspect (str, None, "auto", Tool or Tool[]): the tool to set active for inspect
* active_scroll (str, None, "auto" or Tool): the tool to set active for scroll
* active_tap (str, None, "auto" or Tool): the tool to set active for tap
* active_multi (str, None, "auto" or Tool): the tool to set active for tap
"""
function tools!(
        fig            :: Models.Plot,
        tools          :: Union{AbstractString, Vector{Union{Symbol, AbstractString, Models.iTool}}} = "";
        tooltips       :: Union{Missing, AbstractString, AbstractVector}                             = missing,
        active_drag    :: ActiveArg{Models.iDrag}                                                    = nothing,
        active_inspect :: ActiveArg{Models.iInspectTool}                                             = nothing,
        active_scroll  :: ActiveArg{Models.iScroll}                                                  = nothing,
        active_tap     :: ActiveArg{Models.iGestureTool}                                             = nothing,
        active_multi   :: ActiveArg{Models.iGestureTool}                                             = nothing,
        dotrigger      :: Bool                                                                       = true,
)
    lst = _toollist(tools)
    _tooltips!(lst, tooltips, dotrigger)

    arr = [i.tool for i ∈ lst if i.keep]
    append!(fig.toolbar.tools, arr; dotrigger)

    _active!(fig.toolbar,  active_drag,     :active_drag,     dotrigger, lst)
    _active!(fig.toolbar,  active_inspect,  :active_inspect,  dotrigger, lst)
    _active!(fig.toolbar,  active_scroll,   :active_scroll,   dotrigger, lst)
    _active!(fig.toolbar,  active_tap,      :active_tap,      dotrigger, lst)
    _active!(fig.toolbar,  active_multi,    :active_multi,    dotrigger, lst)
end

function tools!(plot :: Models.Plot, opts :: Models.FigureOptions; dotrigger :: Bool = true)
    tools!(
        plot, Model.bokehunwrap(opts.tools);
        tooltips       = something(Model.bokehunwrap(opts.tooltips), missing),
        active_drag    = opts.active_drag    isa Model.EnumType ? opts.active_drag.value    : opts.active_drag,
        active_inspect = opts.active_inspect isa Model.EnumType ? opts.active_inspect.value : opts.active_inspect,
        active_scroll  = opts.active_scroll  isa Model.EnumType ? opts.active_scroll.value  : opts.active_scroll,
        active_tap     = opts.active_tap     isa Model.EnumType ? opts.active_tap.value     : opts.active_tap,
        active_multi   = opts.active_multi   isa Model.EnumType ? opts.active_multi.value   : opts.active_multi,
        dotrigger
    )
end
end

using .ToolsPlotting: tools!
