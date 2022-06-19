module ActionEvents
using ..Model
using ..Events: iEvent
using ..ModelTypes: iAbstractButton, iPlot, iModel
abstract type iActionEvent <: iEvent end
abstract type iDocActionEvent <: iActionEvent end
abstract type iModelActionEvent <: iActionEvent end
abstract type iPlotActionEvent <: iModelActionEvent end

"""Announce when a Document is fully idle."""
@Base.kwdef struct DocumentReady <: iDocActionEvent end

"""Announce a button click event on a Bokeh button widget."""
@Base.kwdef struct ButtonClick <: iModelActionEvent
    model::iAbstractButton
end

"""Announce a button click event on a Bokeh menu item."""
@Base.kwdef struct MenuItemClick <: iModelActionEvent
    model::iAbstractButton
    item ::String
end

""" Announce the start of "interactive level-of-detail" mode on a plot.

During interactive actions such as panning or zooming, Bokeh can
optionally, temporarily draw a reduced set of the data, in order to
maintain high interactive rates. This is referred to as interactive
Level-of-Detail (LOD) mode. This event fires whenever a LOD mode
has just begun.

"""
@Base.kwdef struct LODStart <: iPlotActionEvent
    model::iPlot
end

""" Announce the end of "interactive level-of-detail" mode on a plot.

During interactive actions such as panning or zooming, Bokeh can
optionally, temporarily draw a reduced set of the data, in order to
maintain high interactive rates. This is referred to as interactive
Level-of-Detail (LOD) mode. This event fires whenever a LOD mode
has just ended.

"""
@Base.kwdef struct LODEnd <: iPlotActionEvent
    model::iPlot
end

""" Announce combined range updates in a single event.

Attributes:
    x0 (float) : start x-coordinate for the default x-range
    x1 (float) : end x-coordinate for the default x-range
    y0 (float) : start x-coordinate for the default y-range
    y1 (float) : end y-coordinate for the default x-range

Callbacks may be added to range ``start`` and ``end`` properties to respond
to range changes, but this can result in multiple callbacks being invoked
for a single logical operation (e.g. a pan or zoom). This event is emitted
by supported tools when the entire range update is complete, in order to
afford a *single* event that can be responded to.

"""
@Base.kwdef struct RangesUpdate <: iPlotActionEvent
    model::iPlot
    x0   ::Union{Missing, Float64} = missing
    x1   ::Union{Missing, Float64} = missing
    y0   ::Union{Missing, Float64} = missing
    y1   ::Union{Missing, Float64} = missing
end

""" Announce the coordinates of a selection event on a plot.

Attributes:
    geometry (dict) : a dictionary containing the coordinates of the
        selection event.
    final (bool) : whether the selection event is the last selection event
        in the case of selections on every mousemove.

"""
struct SelectionGeometry <: iPlotActionEvent
    model    :: iModel
    geometry :: NamedTuple
    final    :: Bool
end

function Selectiongeometry(; model :: iModel, geometry = (;), final :: Bool = true)
    Selectiongeometry(
        model,
        (; (Symbol(i)=>j for (i,j) ∈ geometry)...),
        final
    )
end

""" Announce a button click event on a plot ``ResetTool``. """
@Base.kwdef struct Reset <: iPlotActionEvent
    model :: iModel
end

""" Base class for UI events associated with a specific (x,y) point.

Attributes:
    sx (float) : x-coordinate of the event in *screen* space
    sy (float) : y-coordinate of the event in *screen* space
    x (float) : x-coordinate of the event in *data* space
    y (float) : y-coordinate of the event in *data* space

Note that data space coordinates are relative to the default range, not
any extra ranges, and the the screen space origin is at the top left of
the HTML canvas.

"""
abstract type iPointEvent <: iPlotActionEvent end

for cls ∈ (
    :Tap, :DoubleTap, :Press, :PressUp, :MouseEnter, :MouseLeave, :MouseMove,
    :PanEnd, :PanStart, :PinchStart, :Rotate, :RotateStart, :RotateEnd,
)
    @eval @Base.kwdef struct $cls <: iPointEvent
        model::iPlot
        sx :: Union{Missing, Float64} = missing
        sy :: Union{Missing, Float64} = missing
        x  :: Union{Missing, Float64} = missing
        y  :: Union{Missing, Float64} = missing
    end
end

""" Announce a mouse wheel event on a Bokeh plot.

Attributes:
    delta (float) : the (signed) scroll speed
    sx (float) : x-coordinate of the event in *screen* space
    sy (float) : y-coordinate of the event in *screen* space
    x (float) : x-coordinate of the event in *data* space
    y (float) : y-coordinate of the event in *data* space


.. note::
    By default, Bokeh plots do not prevent default scroll events unless a
    ``WheelZoomTool`` or ``WheelPanTool`` is active. This may change in
    future releases.

"""
@Base.kwdef struct MouseWheel <: iPointEvent
    model :: iModel
    delta :: Union{Missing, Float64} = missing
    sx    :: Union{Missing, Float64} = missing
    sy    :: Union{Missing, Float64} = missing
    x     :: Union{Missing, Float64} = missing
    y     :: Union{Missing, Float64} = missing
end

""" Announce a pan event on a Bokeh plot.

Attributes:
    delta_x (float) : the amount of scroll in the x direction
    delta_y (float) : the amount of scroll in the y direction
    direction (float) : the direction of scroll (1 or -1)
    sx (float) : x-coordinate of the event in *screen* space
    sy (float) : y-coordinate of the event in *screen* space
    x (float) : x-coordinate of the event in *data* space
    y (float) : y-coordinate of the event in *data* space

"""
@Base.kwdef struct Pan <: iPointEvent
    model     :: iModel
    delta_x   :: Union{Missing, Float64} = missing
    delta_y   :: Union{Missing, Float64} = missing
    direction :: Union{Missing, Float64} = missing
    sx        :: Union{Missing, Float64} = missing
    sy        :: Union{Missing, Float64} = missing
    x         :: Union{Missing, Float64} = missing
    y         :: Union{Missing, Float64} = missing
end

""" Announce a pinch event on a Bokeh plot.

Attributes:
    scale (float) : the (signed) amount of scaling
    sx (float) : x-coordinate of the event in *screen* space
    sy (float) : y-coordinate of the event in *screen* space
    x (float) : x-coordinate of the event in *data* space
    y (float) : y-coordinate of the event in *data* space

.. note::
    This event is only applicable for touch-enabled devices.

"""
@Base.kwdef struct Pinch <: iPointEvent
    model     :: iModel
    scale     :: Union{Missing, Float64} = missing
    sx        :: Union{Missing, Float64} = missing
    sy        :: Union{Missing, Float64} = missing
    x         :: Union{Missing, Float64} = missing
    y         :: Union{Missing, Float64} = missing
end


const _EVENT_TYPES = (;
    document_ready  = DocumentReady,
    button_click    = ButtonClick,
    menu_item_click = MenuItemClick,
    (
        Symbol(lowercase("$cls")) => getfield((@__MODULE__), cls)
        for cls ∈ names((@__MODULE__); all = true)
        if "$cls"[1] != '_' && let itm = getfield((@__MODULE__), cls)
            itm isa DataType && itm <: iActionEvent &&
            nameof(itm) ∉ (:DocumentReady, :ButtonClick, :MenuItemClick)
        end
    )...
)

const _EVENT_NAMES = (; (nameof(j) => i for (i, j) ∈ pairs(_EVENT_TYPES))...)

actionevent(name::Symbol, values)   = getfield(_EVENTS, name)(; (Symbol(i)=>j for (i,j) ∈ values)...)
actionname(T::Type{<:iActionEvent}) = getfield(_EVENT_NAMES, nameof(T))

export actionname, actionevent, iActionEvent, iPlotActionEvent, iDocActionEvent, iModelActionEvent
end
using .ActionEvents
