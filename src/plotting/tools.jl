module ToolsPlotting
using ...AbstractTypes
using ...Model
using ...Models

function defaulttool(σ::Symbol) :: Models.iTool
    return if σ ≡ :pan
        Models.PanTool(dimensions=:both)
    elseif σ ≡ :xpan
        Models.PanTool(dimensions=:width)
    elseif σ ≡ :ypan
        Models.PanTool(dimensions=:height)
    elseif σ ≡ :xwheel_pan
        Models.WheelPanTool(dimension=:width)
    elseif σ ≡ :ywheel_pan
        Models.WheelPanTool(dimension=:height)
    elseif σ ≡ :wheel_zoom
        Models.WheelZoomTool(dimensions=:both)
    elseif σ ≡ :xwheel_zoom
        Models.WheelZoomTool(dimensions=:width)
    elseif σ ≡ :ywheel_zoom
        Models.WheelZoomTool(dimensions=:height)
    elseif σ ≡ :zoom_in
        Models.ZoomInTool(dimensions=:both)
    elseif σ ≡ :xzoom_in
        Models.ZoomInTool(dimensions=:width)
    elseif σ ≡ :yzoom_in
        Models.ZoomInTool(dimensions=:height)
    elseif σ ≡ :zoom_out
        Models.ZoomOutTool(dimensions=:both)
    elseif σ ≡ :xzoom_out
        Models.ZoomOutTool(dimensions=:width)
    elseif σ ≡ :yzoom_out
        Models.ZoomOutTool(dimensions=:height)
    elseif σ ≡ :click
        Models.TapTool(behavior=:inspect)
    elseif σ ≡ :tap
        Models.TapTool()
    elseif σ ≡ :doubletap
        Models.TapTool(gesture=:doubletap)
    elseif σ ≡ :crosshair
        Models.CrosshairTool()
    elseif σ ≡ :box_select
        Models.BoxSelectTool()
    elseif σ ≡ :xbox_select
        Models.BoxSelectTool(dimensions=:width)
    elseif σ ≡ :ybox_select
        Models.BoxSelectTool(dimensions=:height)
    elseif σ ≡ :poly_select
        Models.PolySelectTool()
    elseif σ ≡ :lasso_select
        Models.LassoSelectTool()
    elseif σ ≡ :box_zoom
        Models.BoxZoomTool(dimensions=:both)
    elseif σ ≡ :xbox_zoom
        Models.BoxZoomTool(dimensions=:width)
    elseif σ ≡ :ybox_zoom
        Models.BoxZoomTool(dimensions=:height)
    elseif σ ≡ :save
        Models.SaveTool()
    elseif σ ≡ :undo
        Models.UndoTool()
    elseif σ ≡ :redo
        Models.RedoTool()
    elseif σ ≡ :reset
        Models.ResetTool()
    elseif σ ≡ :help
        Models.HelpTool()
    elseif σ ≡ :box_edit
        Models.BoxEditTool()
    elseif σ ≡ :line_edit
        Models.LineEditTool()
    elseif σ ≡ :point_draw
        Models.PointDrawTool()
    elseif σ ≡ :poly_draw
        Models.PolyDrawTool()
    elseif σ ≡ :poly_edit
        Models.PolyEditTool()
    elseif σ ≡ :freehand_draw
        Models.FreehandDrawTool()
    elseif σ ≡ :hover
        Models.HoverTool(tooltips=[
            ("index",         "\$index"),
            ("data (x, y)",   "(\$x, \$y)"),
            ("screen (x, y)", "(\$sx, \$sy)"),
        ])
    else
        throw(BokehException("Unknown tool shorthand $σ"))
    end
end
defaulttool(x::Models.iTool) = x
defaulttool(x::AbstractString) = defaulttool(Symbol(strip(x)))

Model.bokehconvert(::Type{Models.iTool}, x::Union{Models.iTool, AbstractString, Symbol, Val}) = defaulttool(x)

struct _ToolInfo
    tool :: Models.iTool
    arg  :: Union{Models.iTool, Symbol}
    keep :: Bool
end

function _isdiff(@nospecialize(x), @nospecialize(y))
    return if x isa iHasProps
        if (typeof(x) ≡ typeof(y))
            any(
                _isdiff(getproperty(x, k), getproperty(y, k))
                for k ∈ propertynames(lst[i])
                if k ≢ :id
            )
        else
            true
        end
    else
        !Model.compare(x, y)
    end
end

_toollist(t::AbstractString) = _toollist(split(t, ','))
function _toollist(
    tools :: AbstractVector{<:Union{Symbol, AbstractString, Models.iTool}},
)
    lst = Models.iTool[defaulttool.(i) for i ∈ tools]
    keeps = let keeps = ones(Bool, length(lst))

        for i ∈ 1:length(lst)-1
            keeps[i] && for j ∈ (i+1) : length(lst)
                keeps[j] = keeps[j] && _isdiff(lst[i], lst[j])
            end
        end
        keeps
    end

    return _ToolInfo[
        _ToolInfo(tool, (arg isa AbstractString ? Symbol(strip(arg)) : arg), keep)
        for (tool, arg, keep) ∈ zip(lst, tools, keeps)
    ]
end

_tooltips!(::Vector{_ToolInfo}, ::Missing, ::Bool) = nothing
function _tooltips!(lst::Vector{_ToolInfo}, tooltips, dotrigger :: Bool)
    @nospecialize lst _tooltips
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

function _active!(tb::Models.iToolbar, val::Union{Nothing, Models.iTool}, attr::Symbol, dotrigger::Bool, ::Vector{_ToolInfo})
    setproperty!(tb, attr, val; dotrigger)
end

function _active!(tb::Models.iToolbar, val::AbstractString, attr::Symbol, dotrigger::Bool, lst::Vector{_ToolInfo})
    _active!(tb, Symbol(strip(val)), attr, dotrigger, lst)
end

function _active!(tb::Models.iToolbar, val::Symbol, attr::Symbol, dotrigger::Bool, lst::Vector{_ToolInfo})
    if val ≡ :auto
        setproperty!(tb, attr, :auto; dotrigger)
    else
        for i ∈ lst 
            if i.arg ≡ val
                setproperty!(tb, attr, i.tool; dotrigger)
                break
            end
        end
        throw(BokehException("Could not find tool `$val` to activate"))
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
    @nospecialize fig tools
    lst = _toollist(tools)
    _tooltips!(lst, tooltips, dotrigger)

    arr = Models.iTool[i.tool for i ∈ lst if i.keep]
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
