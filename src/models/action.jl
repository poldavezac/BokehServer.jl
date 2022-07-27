module Actions
using ...AbstractTypes
using ...Model
using ...Events
using ...Protocol
using ..Models: iAbstractButton, iPlot, iModel, iDropdown
abstract type iPlotActionEvent <: Events.iModelActionEvent end

"""Announce when a Document is fully idle."""
@Base.kwdef struct DocumentReady <: Events.iDocActionEvent
    doc::iDocument
end

"""Announce a button click event on a BokehServer button widget."""
@Base.kwdef struct ButtonClick <: Events.iModelActionEvent
    model::iAbstractButton
end

"""Announce a button click event on a BokehServer menu item."""
@Base.kwdef struct MenuItemClick <: Events.iModelActionEvent
    model::iAbstractButton
    item ::String
end

""" Announce the start of "interactive level-of-detail" mode on a plot.

During interactive actions such as panning or zooming, BokehServer can
optionally, temporarily draw a reduced set of the data, in order to
maintain high interactive rates. This is referred to as interactive
Level-of-Detail (LOD) mode. This event fires whenever a LOD mode
has just begun.

Fields:

* `model::iPlot`: the plot affected by the event
"""
@Base.kwdef struct LODStart <: iPlotActionEvent
    model::iPlot
end

""" Announce the end of "interactive level-of-detail" mode on a plot.

During interactive actions such as panning or zooming, BokehServer can
optionally, temporarily draw a reduced set of the data, in order to
maintain high interactive rates. This is referred to as interactive
Level-of-Detail (LOD) mode. This event fires whenever a LOD mode
has just ended.

Fields:

* `model::iPlot`: the plot affected by the event

"""
@Base.kwdef struct LODEnd <: iPlotActionEvent
    model::iPlot
end

""" Announce combined range updates in a single event.

Fields:

* `model::iPlot`: the plot affected by the event
* `x0::Float64`: start x-coordinate for the default x-range
* `x1::Float64`: end x-coordinate for the default x-range
* `y0::Float64`: start x-coordinate for the default y-range
* `y1::Float64`: end y-coordinate for the default x-range

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

Fields:

* `model::iModel`: the model affected by the event
* `geometry::DICT`: a dictionary containing the coordinates of the selection
event.
* `final::BOOL`: whether the selection event is the last selection event in the
case of selections on every mousemove.

"""
struct SelectionGeometry <: iPlotActionEvent
    model    :: iModel
    geometry :: NamedTuple
    final    :: Bool
end

function SelectionGeometry(; model :: iModel, geometry = (;), final :: Bool = true)
    SelectionGeometry(
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

Fields:

* `model::iPlot`: the plot affected by the event
* `sx::Float64`: x-coordinate of the event in *screen* space
* `sy::Float64`: y-coordinate of the event in *screen* space
* `x::Float64`: x-coordinate of the event in *data* space
* `y::Float64`: y-coordinate of the event in *data* space

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

    eval(:(@doc($(""" Announce a `$cls` event on a BokehServer plot.

    Fields:

    * `model::iPlot`: the plot affected by the event
    * `sx::Float64`: x-coordinate of the event in *screen* space
    * `sy::Float64`: y-coordinate of the event in *screen* space
    * `x::Float64`: x-coordinate of the event in *data* space
    * `y::Float64`: y-coordinate of the event in *data* space
    """), $cls)))
end

""" Announce a mouse wheel event on a BokehServer plot.

Fields:

* `model::iPlot`: the plot affected by the event
* `delta::Float64`: the (signed) scroll speed
* `sx::Float64`: x-coordinate of the event in *screen* space
* `sy::Float64`: y-coordinate of the event in *screen* space
* `x::Float64`: x-coordinate of the event in *data* space
* `y::Float64`: y-coordinate of the event in *data* space


*Note* By default, BokehServer plots do not prevent default scroll events unless a    ``WheelZoomTool`` or ``WheelPanTool`` is active. This may change in
    future releases.

"""
@Base.kwdef struct MouseWheel <: iPointEvent
    model :: iPlot
    delta :: Union{Missing, Float64} = missing
    sx    :: Union{Missing, Float64} = missing
    sy    :: Union{Missing, Float64} = missing
    x     :: Union{Missing, Float64} = missing
    y     :: Union{Missing, Float64} = missing
end

""" Announce a pan event on a BokehServer plot.

Fields:

* `model::iPlot`: the plot affected by the event
* `delta_x::Float64`: the amount of scroll in the x direction
* `delta_y::Float64`: the amount of scroll in the y direction
* `direction::Float64`: the direction of scroll (1 or -1)
* `sx::Float64`: x-coordinate of the event in *screen* space
* `sy::Float64`: y-coordinate of the event in *screen* space
* `x::Float64`: x-coordinate of the event in *data* space
* `y::Float64`: y-coordinate of the event in *data* space
"""
@Base.kwdef struct Pan <: iPointEvent
    model     :: iPlot
    delta_x   :: Union{Missing, Float64} = missing
    delta_y   :: Union{Missing, Float64} = missing
    direction :: Union{Missing, Float64} = missing
    sx        :: Union{Missing, Float64} = missing
    sy        :: Union{Missing, Float64} = missing
    x         :: Union{Missing, Float64} = missing
    y         :: Union{Missing, Float64} = missing
end

""" Announce a pinch event on a BokehServer plot.

Fields:

* `model::iPlot`: the plot affected by the event
* `scale::Float64`: the (signed) amount of scaling
* `sx::Float64`: x-coordinate of the event in *screen* space
* `sy::Float64`: y-coordinate of the event in *screen* space
* `x::Float64`: x-coordinate of the event in *data* space
* `y::Float64`: y-coordinate of the event in *data* space

*Note* This event is only applicable for touch-enabled devices.
"""
@Base.kwdef struct Pinch <: iPointEvent
    model     :: iPlot
    scale     :: Union{Missing, Float64} = missing
    sx        :: Union{Missing, Float64} = missing
    sy        :: Union{Missing, Float64} = missing
    x         :: Union{Missing, Float64} = missing
    y         :: Union{Missing, Float64} = missing
end

Base.propertynames(::T; private::Bool = false) where {T <: Events.iActionEvent} = (fieldnames(T)..., :event_name)

function Base.getproperty(μ::T, σ::Symbol) where {T <: Events.iActionEvent}
    return σ ≡ :event_name ? getfield(_EVENT_NAMES, nameof(T)) : getfield(μ, σ)
end

const _EVENT_NAMES = (;
    (
        cls => Symbol(lowercase("$cls"))
        for cls ∈ names((@__MODULE__); all = true)
        if "$cls"[1] != '_' && let itm = getfield((@__MODULE__), cls)
            itm isa DataType && itm <: Events.iActionEvent
        end
    )...,
    DocumentReady = :document_ready,
    ButtonClick   = :button_click,
    MenuItemClick = :menu_item_click,
)

const _EVENT_TYPES = (; (j => getfield((@__MODULE__), i) for (i, j) ∈ pairs(_EVENT_NAMES))...)

Events.eventtypes(::iModel)             = (Events.iDocModelEvent,)
Events.eventtypes(::iPlot)              = (Events.iDocModelEvent, (i for i ∈ values(_EVENT_TYPES) if i <: iPlotActionEvent)...)
Events.eventtypes(::iAbstractButton)    = (Events.iDocModelEvent, ButtonClick)
Events.eventtypes(::iDropdown)          = (Events.iDocModelEvent, ButtonClick, MenuItemClick)
Events.eventtypes(::iDocument)          = (Events.iDocEvent, DocumentReady)
Events.eventcallbacks(e::DocumentReady) = e.doc.callbacks

function Events.pushcallback!(μ::Union{iPlot, iAbstractButton}, 𝐹::Function, 𝑇s::Tuple)
    push!(μ.callbacks, 𝐹)
    for T ∈ 𝑇s
        n = get(_EVENT_NAMES, nameof(T), missing)
        (!ismissing(n) && (n ∉ μ.subscribed_events)) && push!(μ.subscribed_events, n)
    end
    𝐹
end

"""
    action!(𝐷::iDocument, ::Val{T}; model::iModel, k...) where {T}

Calls callbacks linked to the event associated with arguments and keywords.
"""
action!(𝐷::iDocument, ::Val{:document_ready}; k...) = Events.executecallbacks(DocumentReady(𝐷))
function action!(𝐷::iDocument, ::Val{T}; model::iModel, k...) where {T}
    Events.executecallbacks(getfield(_EVENT_TYPES, T)(; model, k...))
end

function Protocol.Deserialize.apply(::Val{:MessageSent}, 𝐷::iDocument, 𝐼::Dict{String}, 𝑀)
    if 𝐼["msg_type"] == "bokeh_event"
        data = 𝐼["msg_data"]
        action!(
            𝐷,
            Val(Symbol(data["event_name"]));
            (Symbol(i) => Protocol.Deserialize.deserialize(Any, j, 𝑀) for (i, j) ∈ data["event_values"])...
        )
    end
end
end

using .Actions: DocumentReady, ButtonClick, MenuItemClick, LODStart, LODEnd, RangesUpdate, SelectionGeometry,
       Reset, Tap, DoubleTap, Press, PressUp, MouseEnter, MouseLeave, MouseMove,
       PanEnd, PanStart, PinchStart, Rotate, RotateStart, RotateEnd, MouseWheel, Pan, Pinch

export DocumentReady, ButtonClick, MenuItemClick, LODStart, LODEnd, RangesUpdate, SelectionGeometry,
       Reset, Tap, DoubleTap, Press, PressUp, MouseEnter, MouseLeave, MouseMove,
       PanEnd, PanStart, PinchStart, Rotate, RotateStart, RotateEnd, MouseWheel, Pan, Pinch
