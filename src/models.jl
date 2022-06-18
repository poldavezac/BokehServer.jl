#- file created by @__PATH__: do not edit! -#
module Models
using Dates
using ..Bokeh
using ..Model
using ..AbstractTypes
const iTemplate = String
abstract type iTicker <: iModel end
abstract type iContinuousTicker <: iTicker end
abstract type iDOMNode <: iModel end
abstract type iDOMElement <: iDOMNode end
abstract type iDomSpan <: iDOMElement end
abstract type iTool <: iModel end
abstract type iGestureTool <: iTool end
abstract type iSelectTool <: iGestureTool end
abstract type iAbstractIcon <: iModel end
abstract type iGlyph <: iModel end
abstract type iXYGlyph <: iGlyph end
abstract type iImageRGBA <: iXYGlyph end
abstract type iLegendItem <: iModel end
abstract type iRenderer <: iModel end
abstract type iAnnotation <: iRenderer end
abstract type iPolyAnnotation <: iAnnotation end
abstract type iSingleIntervalTicker <: iContinuousTicker end
abstract type iYearsTicker <: iSingleIntervalTicker end
abstract type iActionTool <: iTool end
abstract type iHelpTool <: iActionTool end
abstract type iArrowHead <: iModel end
abstract type iNormalHead <: iArrowHead end
abstract type iText <: iGlyph end
abstract type iDrag <: iGestureTool end
abstract type iPanTool <: iDrag end
abstract type iInspectTool <: iGestureTool end
abstract type iHoverTool <: iInspectTool end
abstract type iFillGlyph <: iGlyph end
abstract type iCellEditor <: iModel end
abstract type iStringEditor <: iCellEditor end
abstract type iMapOptions <: iModel end
abstract type iGMapOptions <: iMapOptions end
abstract type iTransform <: iModel end
abstract type iScale <: iTransform end
abstract type iWedge <: iGlyph end
abstract type iLayoutDOM <: iModel end
abstract type iWidget <: iLayoutDOM end
abstract type iTableWidget <: iWidget end
abstract type iDataTable <: iTableWidget end
abstract type iTileSource <: iModel end
abstract type iMercatorTileSource <: iTileSource end
abstract type iTMSTileSource <: iMercatorTileSource end
abstract type iTableColumn <: iModel end
abstract type iScroll <: iGestureTool end
abstract type iRowAggregator <: iModel end
abstract type iBaseText <: iModel end
abstract type iPlainText <: iBaseText end
abstract type iPlaceholder <: iDOMNode end
abstract type iValueRef <: iPlaceholder end
abstract type iDomColorRef <: iValueRef end
abstract type iConnectedXYGlyph <: iXYGlyph end
abstract type iTickFormatter <: iModel end
abstract type iBasicTickFormatter <: iTickFormatter end
abstract type iMercatorTickFormatter <: iBasicTickFormatter end
abstract type iGraphHitTestPolicy <: iModel end
abstract type iExpression <: iModel end
abstract type iXYComponent <: iExpression end
abstract type iXComponent <: iXYComponent end
abstract type iTextAnnotation <: iAnnotation end
abstract type iLabel <: iTextAnnotation end
abstract type iAbstractSlider <: iWidget end
abstract type iDateSlider <: iAbstractSlider end
abstract type iInputWidget <: iWidget end
abstract type iYComponent <: iXYComponent end
abstract type iSpacer <: iLayoutDOM end
abstract type iJitter <: iTransform end
abstract type iZoomOutTool <: iActionTool end
abstract type iAbstractGroup <: iWidget end
abstract type iDataSource <: iModel end
abstract type iColumnarDataSource <: iDataSource end
abstract type iColumnDataSource <: iColumnarDataSource end
abstract type iDaysTicker <: iSingleIntervalTicker end
abstract type iHexTile <: iGlyph end
abstract type iBox <: iLayoutDOM end
abstract type iColumn <: iBox end
abstract type iWidgetBox <: iColumn end
abstract type iContinuousScale <: iScale end
abstract type iLinearScale <: iContinuousScale end
abstract type iMarker <: iGlyph end
abstract type iCircle <: iMarker end
abstract type iFileInput <: iWidget end
abstract type iRedoTool <: iActionTool end
abstract type iNodesAndLinkedEdges <: iGraphHitTestPolicy end
abstract type iMapper <: iTransform end
abstract type iCategoricalColorMapper <: iMapper end
abstract type iMultiPolygons <: iGlyph end
abstract type iCumSum <: iExpression end
abstract type iSlider <: iAbstractSlider end
abstract type iPatch <: iGlyph end
abstract type iMultiChoice <: iInputWidget end
abstract type iSpan <: iAnnotation end
abstract type iBoxAnnotation <: iAnnotation end
abstract type iTextLikeInput <: iInputWidget end
abstract type iTextAreaInput <: iTextLikeInput end
abstract type iGuideRenderer <: iRenderer end
abstract type iAxis <: iGuideRenderer end
abstract type iContinuousAxis <: iAxis end
abstract type iLinearAxis <: iContinuousAxis end
abstract type iAnnularWedge <: iGlyph end
abstract type iDomTemplate <: iDOMElement end
abstract type iCategoricalTickFormatter <: iTickFormatter end
abstract type iDatetimeRangeSlider <: iAbstractSlider end
abstract type iCoordinateTransform <: iExpression end
abstract type iGraphCoordinates <: iCoordinateTransform end
abstract type iNodeCoordinates <: iGraphCoordinates end
abstract type iRangeTool <: iDrag end
abstract type iNumberEditor <: iCellEditor end
abstract type iPlot <: iLayoutDOM end
abstract type iMapPlot <: iPlot end
abstract type iGMapPlot <: iMapPlot end
abstract type iCrosshairTool <: iInspectTool end
abstract type iCellFormatter <: iModel end
abstract type iBooleanFormatter <: iCellFormatter end
abstract type iEllipse <: iGlyph end
abstract type iBoxZoomTool <: iDrag end
abstract type iColorMapper <: iMapper end
abstract type iDataAnnotation <: iAnnotation end
abstract type iArrow <: iDataAnnotation end
abstract type iDomDiv <: iDOMElement end
abstract type iTexture <: iModel end
abstract type iCanvasTexture <: iTexture end
abstract type iOval <: iGlyph end
abstract type iLabelingPolicy <: iModel end
abstract type iAllLabels <: iLabelingPolicy end
abstract type iGeoJSONDataSource <: iColumnarDataSource end
abstract type iMinAggregator <: iRowAggregator end
abstract type iDomPlaceholder <: iDOMNode end
abstract type iMaxAggregator <: iRowAggregator end
abstract type iMathText <: iBaseText end
abstract type iTileRenderer <: iRenderer end
abstract type iImageURL <: iXYGlyph end
abstract type iMarkup <: iWidget end
abstract type iParagraph <: iMarkup end
abstract type iPreText <: iParagraph end
abstract type iAbstractButton <: iWidget end
abstract type iDropdown <: iAbstractButton end
abstract type iTextInput <: iTextLikeInput end
abstract type iAutocompleteInput <: iTextInput end
abstract type iAscii <: iMathText end
abstract type iFilter <: iModel end
abstract type iIndexFilter <: iFilter end
abstract type iPrintfTickFormatter <: iTickFormatter end
abstract type iCDSView <: iModel end
abstract type iCustomJSExpr <: iExpression end
abstract type iToolbarPanel <: iAnnotation end
abstract type iCallback <: iModel end
abstract type iCustomJSTransform <: iTransform end
abstract type iStringFormatter <: iCellFormatter end
abstract type iNumberFormatter <: iStringFormatter end
abstract type iContinuousColorMapper <: iColorMapper end
abstract type iRange <: iModel end
abstract type iRange1d <: iRange end
abstract type iPolarTransform <: iCoordinateTransform end
abstract type iVeeHead <: iArrowHead end
abstract type iLinearColorMapper <: iContinuousColorMapper end
abstract type iSelection <: iModel end
abstract type iStep <: iGlyph end
abstract type iNumericInput <: iInputWidget end
abstract type iSpinner <: iNumericInput end
abstract type iScalarExpression <: iModel end
abstract type iMinimum <: iScalarExpression end
abstract type iHatchGlyph <: iGlyph end
abstract type iDomTable <: iDOMElement end
abstract type iButtonGroup <: iAbstractGroup end
abstract type iRadioButtonGroup <: iButtonGroup end
abstract type iTextGlyph <: iGlyph end
abstract type iCompositeTicker <: iContinuousTicker end
abstract type iBand <: iDataAnnotation end
abstract type iRay <: iGlyph end
abstract type iSelectionPolicy <: iModel end
abstract type iUnionRenderers <: iSelectionPolicy end
abstract type iLineEditTool <: iGestureTool end
abstract type iTitle <: iTextAnnotation end
abstract type iRendererGroup <: iModel end
abstract type iCategoricalMapper <: iMapper end
abstract type iCategoricalMarkerMapper <: iCategoricalMapper end
abstract type iAction <: iModel end
abstract type iDomToggleGroup <: iAction end
abstract type iFixedTicker <: iContinuousTicker end
abstract type iPasswordInput <: iTextInput end
abstract type iWebDataSource <: iColumnDataSource end
abstract type iServerSentDataSource <: iWebDataSource end
abstract type iQUADKEYTileSource <: iMercatorTileSource end
abstract type iCheckboxButtonGroup <: iButtonGroup end
abstract type iAdaptiveTicker <: iContinuousTicker end
abstract type iLogTicker <: iAdaptiveTicker end
abstract type iEdgeCoordinates <: iGraphCoordinates end
abstract type iCategoricalAxis <: iAxis end
abstract type iStyles <: iModel end
abstract type iTimeEditor <: iCellEditor end
abstract type iSaveTool <: iActionTool end
abstract type iDatetimeAxis <: iLinearAxis end
abstract type iInterpolator <: iTransform end
abstract type iLinearInterpolator <: iInterpolator end
abstract type iDomValueRef <: iPlaceholder end
abstract type iToolbarBox <: iLayoutDOM end
abstract type iCheckboxEditor <: iCellEditor end
abstract type iImage <: iXYGlyph end
abstract type iVBar <: iGlyph end
abstract type iLineGlyph <: iGlyph end
abstract type iDomDOMElement <: iDOMNode end
abstract type iTooltip <: iAnnotation end
abstract type iDomTableRow <: iDOMElement end
abstract type iGroup <: iAbstractGroup end
abstract type iQuad <: iGlyph end
abstract type iPanel <: iModel end
abstract type iUndoTool <: iActionTool end
abstract type iToggle <: iAbstractButton end
abstract type iTap <: iGestureTool end
abstract type iCoordinateMapping <: iModel end
abstract type iDataModel <: iModel end
abstract type iArc <: iGlyph end
abstract type iDataRange <: iRange end
abstract type iScientificFormatter <: iStringFormatter end
abstract type iVArea <: iGlyph end
abstract type iNoOverlap <: iLabelingPolicy end
abstract type iMathML <: iMathText end
abstract type iBasicTicker <: iAdaptiveTicker end
abstract type iDataRenderer <: iRenderer end
abstract type iGraphRenderer <: iDataRenderer end
abstract type iMaximum <: iScalarExpression end
abstract type iDatePicker <: iInputWidget end
abstract type iCustomJS <: iCallback end
abstract type iColorBar <: iAnnotation end
abstract type iToolbarBase <: iModel end
abstract type iToolbar <: iToolbarBase end
abstract type iEditTool <: iGestureTool end
abstract type iHTMLBox <: iLayoutDOM end
abstract type iLogColorMapper <: iContinuousColorMapper end
abstract type iPolyDrawTool <: iGestureTool end
abstract type iSumAggregator <: iRowAggregator end
abstract type iOpenHead <: iArrowHead end
abstract type iPatches <: iGlyph end
abstract type iCategoricalPatternMapper <: iCategoricalMapper end
abstract type iLabelSet <: iDataAnnotation end
abstract type iBezier <: iLineGlyph end
abstract type iDateFormatter <: iStringFormatter end
abstract type iPointDrawTool <: iGestureTool end
abstract type iBinnedTicker <: iTicker end
abstract type iDomAction <: iModel end
abstract type iHArea <: iGlyph end
abstract type iWhisker <: iDataAnnotation end
abstract type iLassoSelectTool <: iGestureTool end
abstract type iButton <: iAbstractButton end
abstract type iNodesOnly <: iGraphHitTestPolicy end
abstract type iTextEditor <: iCellEditor end
abstract type iTapTool <: iGestureTool end
abstract type iLayoutProvider <: iModel end
abstract type iStaticLayoutProvider <: iLayoutProvider end
abstract type iDataRange1d <: iDataRange end
abstract type iDomIndex <: iPlaceholder end
abstract type iBooleanFilter <: iFilter end
abstract type iDatetimeTicker <: iCompositeTicker end
abstract type iStack <: iExpression end
abstract type iDodge <: iTransform end
abstract type iQuadratic <: iLineGlyph end
abstract type iColorPicker <: iInputWidget end
abstract type iLegend <: iAnnotation end
abstract type iGroupingInfo <: iModel end
abstract type iCustomAction <: iActionTool end
abstract type iBoxEditTool <: iGestureTool end
abstract type iPolyTool <: iEditTool end
abstract type iCustomJSHover <: iModel end
abstract type iDomDOMNode <: iModel end
abstract type iIntersectRenderers <: iSelectionPolicy end
abstract type iWheelPanTool <: iScroll end
abstract type iSelectEditor <: iCellEditor end
abstract type iFactorRange <: iRange end
abstract type iTeeHead <: iArrowHead end
abstract type iHTMLTemplateFormatter <: iCellFormatter end
abstract type iScanningColorMapper <: iContinuousColorMapper end
abstract type iEqHistColorMapper <: iScanningColorMapper end
abstract type iLogAxis <: iContinuousAxis end
abstract type iGroupFilter <: iFilter end
abstract type iAjaxDataSource <: iWebDataSource end
abstract type iWheelZoomTool <: iScroll end
abstract type iDateRangeSlider <: iAbstractSlider end
abstract type iMercatorTicker <: iBasicTicker end
abstract type iHBar <: iGlyph end
abstract type iDateEditor <: iCellEditor end
abstract type iMultiLine <: iLineGlyph end
abstract type iScatter <: iMarker end
abstract type iCustomJSFilter <: iFilter end
abstract type iResetTool <: iActionTool end
abstract type iRadioGroup <: iGroup end
abstract type iRangeSlider <: iAbstractSlider end
abstract type iTabs <: iLayoutDOM end
abstract type iGlyphRenderer <: iDataRenderer end
abstract type iBBoxTileSource <: iMercatorTileSource end
abstract type iEdgesAndLinkedNodes <: iGraphHitTestPolicy end
abstract type iPercentEditor <: iCellEditor end
abstract type iSlope <: iAnnotation end
abstract type iRect <: iGlyph end
abstract type iAnnulus <: iGlyph end
abstract type iFuncTickFormatter <: iTickFormatter end
abstract type iProxyToolbar <: iToolbarBase end
abstract type iImageURLTexture <: iTexture end
abstract type iOpenURL <: iCallback end
abstract type iCategoricalTicker <: iTicker end
abstract type iIntEditor <: iCellEditor end
abstract type iSelect <: iInputWidget end
abstract type iWMTSTileSource <: iMercatorTileSource end
abstract type iAvgAggregator <: iRowAggregator end
abstract type iLine <: iGlyph end
abstract type iMultiSelect <: iInputWidget end
abstract type iLogTickFormatter <: iTickFormatter end
abstract type iGridBox <: iLayoutDOM end
abstract type iZoomInTool <: iActionTool end
abstract type iBoxSelectTool <: iGestureTool end
abstract type iRow <: iBox end
abstract type iPolySelectTool <: iGestureTool end
abstract type iGrid <: iGuideRenderer end
abstract type iNumeralTickFormatter <: iTickFormatter end
abstract type iEdgesOnly <: iGraphHitTestPolicy end
abstract type iFreehandDrawTool <: iGestureTool end
abstract type iCategoricalScale <: iScale end
abstract type iMercatorAxis <: iLinearAxis end
abstract type iCheckboxGroup <: iGroup end
abstract type iSegment <: iLineGlyph end
abstract type iDatetimeTickFormatter <: iTickFormatter end
abstract type iPolyEditTool <: iGestureTool end
abstract type iStepInterpolator <: iInterpolator end
abstract type iDomText <: iDOMNode end
abstract type iDataCube <: iDataTable end
abstract type iMonthsTicker <: iSingleIntervalTicker end
abstract type iCustomLabelingPolicy <: iLabelingPolicy end
abstract type iDiv <: iMarkup end
abstract type iLogScale <: iContinuousScale end
abstract type iTeX <: iMathText end

@model mutable struct ContinuousTicker <: iContinuousTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    subscribed_events :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomSpan <: iDomSpan

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct SelectTool <: iSelectTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct AbstractIcon <: iAbstractIcon

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ImageRGBA <: iImageRGBA

    syncable :: Bool = true

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    dw :: Bokeh.Model.DistanceSpec = (field = "dw",)

    subscribed_events :: Vector{String} = String[]

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    dilate :: Bool = false

    image :: Bokeh.Model.Spec{Float64} = (field = "image",)

    dh_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    name :: Bokeh.Model.Nullable{String} = nothing

    dw_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    dh :: Bokeh.Model.DistanceSpec = (field = "dh",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LegendItem <: iLegendItem

    syncable :: Bool = true

    visible :: Bool = true

    label :: Bokeh.Model.Nullable{Bokeh.Model.Spec{String}} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    index :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PolyAnnotation <: iPolyAnnotation

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    ys :: Vector{Float64} = Float64[]

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    ys_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    line_width :: Float64 = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    hatch_weight :: Bokeh.Model.Size = 1.0

    xs :: Vector{Float64} = Float64[]

    xs_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct YearsTicker <: iYearsTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    subscribed_events :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    interval :: Float64
end

@model mutable struct HelpTool <: iHelpTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    redirect :: String = "https://docs.bokeh.org/en/latest/docs/user_guide/tools.html"

    tags :: Vector{Any}
end

@model mutable struct NormalHead <: iNormalHead

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Text <: iText

    syncable :: Bool = true

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    text :: Bokeh.Model.Spec{String} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    name :: Bokeh.Model.Nullable{String} = nothing

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PanTool <: iPanTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct HoverTool <: iHoverTool

    syncable :: Bool = true

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :center

    line_policy :: Bokeh.Model.EnumType{(:none, :nearest, :interp, :prev, :next)} = :nearest

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    toggleable :: Bool = true

    tooltips :: Union{Nothing, iTemplate, String, Vector{Tuple{String, String}}} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mode :: Bokeh.Model.EnumType{(:mouse, :vline, :hline)} = :mouse

    point_policy :: Bokeh.Model.EnumType{(:snap_to_data, :follow_mouse, :none)} = :snap_to_data

    show_arrow :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    names :: Vector{String} = String[]

    muted_policy :: Bokeh.Model.EnumType{(:ignore, :show)} = :show

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal

    formatters :: Dict{String, Union{iCustomJSHover, Bokeh.Model.EnumType{(:numeral, :datetime, :printf)}}}
end

@model mutable struct FillGlyph <: iFillGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct StringEditor <: iStringEditor

    syncable :: Bool = true

    completions :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct GMapOptions <: iGMapOptions

    syncable :: Bool = true

    scale_control :: Bool = false

    lng :: Float64

    zoom :: Int64 = 12

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    tilt :: Int64 = 45

    styles :: Bokeh.Model.JSONString

    name :: Bokeh.Model.Nullable{String} = nothing

    lat :: Float64

    map_type :: Bokeh.Model.EnumType{(:hybrid, :roadmap, :satellite, :terrain)} = :roadmap

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Scale <: iScale

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Wedge <: iWedge

    syncable :: Bool = true

    start_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    finish_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    start_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    radius :: Bokeh.Model.DistanceSpec = (field = "radius",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DataTable <: iDataTable

    syncable :: Bool = true

    frozen_rows :: Bokeh.Model.Nullable{Int64} = nothing

    index_position :: Bokeh.Model.Nullable{Int64} = 0

    scroll_to_selection :: Bool = true

    css_classes :: Vector{String} = String[]

    header_row :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tags :: Vector{Any}

    disabled :: Bool = false

    row_height :: Int64 = 25

    columns :: Vector{iTableColumn}

    auto_edit :: Bool = false

    index_header :: String = "#"

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    fit_columns :: Bokeh.Model.Nullable{Bool} = nothing

    index_width :: Int64 = 40

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    sortable :: Bool = true

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    selectable :: Union{Bool, Bokeh.Model.EnumType{(:checkbox,)}} = true

    autosize_mode :: Bokeh.Model.EnumType{(:none, :fit_columns, :fit_viewport, :force_fit)} = :force_fit

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    editable :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    reorderable :: Bool = true

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    view :: iCDSView

    frozen_columns :: Bokeh.Model.Nullable{Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct TMSTileSource <: iTMSTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    snap_to_zoom :: Bool = false

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    wrap_around :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LayoutDOM <: iLayoutDOM

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct TableColumn <: iTableColumn

    syncable :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    default_sort :: Bokeh.Model.EnumType{(:ascending, :descending)} = :ascending

    sortable :: Bool = true

    subscribed_events :: Vector{String} = String[]

    formatter :: iCellFormatter = StringFormatter()

    title :: Bokeh.Model.Nullable{String} = nothing

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    editor :: iCellEditor = StringEditor()

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Int64 = 300
end

@model mutable struct Scroll <: iScroll

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct RowAggregator <: iRowAggregator

    syncable :: Bool = true

    field_ :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct PlainText <: iPlainText

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    text :: String

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomColorRef <: iDomColorRef

    syncable :: Bool = true

    hex :: Bool = true

    field :: String

    swatch :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ConnectedXYGlyph <: iConnectedXYGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MercatorTickFormatter <: iMercatorTickFormatter

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    precision :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    power_limit_low :: Int64 = -3

    subscribed_events :: Vector{String} = String[]

    use_scientific :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    dimension :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:lat, :lon)}} = nothing

    power_limit_high :: Int64 = 5

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct GraphHitTestPolicy <: iGraphHitTestPolicy

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct XComponent <: iXComponent

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    transform :: iCoordinateTransform

    tags :: Vector{Any}
end

@model mutable struct Label <: iLabel

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    text_font :: String = "helvetica"

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    text_alpha :: Bokeh.Model.Percent = 1.0

    text :: String = ""

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    border_line_dash_offset :: Int64 = 0

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Float64

    text_line_height :: Float64 = 1.2

    y_offset :: Float64 = 0.0

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    angle :: Float64 = 0.0

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    text_font_size :: Bokeh.Model.FontSize = "16px"

    name :: Bokeh.Model.Nullable{String} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    x_offset :: Float64 = 0.0

    y :: Float64

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    border_line_width :: Float64 = 1.0

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    border_line_dash :: Bokeh.Model.DashPattern

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left
end

@model mutable struct DateSlider <: iDateSlider

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Dates.DateTime}

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Dates.DateTime

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tooltips :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    finish :: Dates.DateTime

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Dates.DateTime

    step :: Int64 = 1

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct InputWidget <: iInputWidget

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct YComponent <: iYComponent

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    transform :: iCoordinateTransform

    tags :: Vector{Any}
end

@model mutable struct Spacer <: iSpacer

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Jitter <: iJitter

    syncable :: Bool = true

    range :: Bokeh.Model.Nullable{iRange} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mean :: Float64 = 0.0

    distribution :: Bokeh.Model.EnumType{(:normal, :uniform)} = :uniform

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Float64 = 1.0
end

@model mutable struct ZoomOutTool <: iZoomOutTool

    syncable :: Bool = true

    factor :: Bokeh.Model.Percent = 0.1

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    maintain_focus :: Bool = true

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MapOptions <: iMapOptions

    syncable :: Bool = true

    lng :: Float64

    name :: Bokeh.Model.Nullable{String} = nothing

    lat :: Float64

    subscribed_events :: Vector{String} = String[]

    zoom :: Int64 = 12

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct AbstractGroup <: iAbstractGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct ColumnDataSource <: iColumnDataSource

    syncable :: Bool = true

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    name :: Bokeh.Model.Nullable{String} = nothing

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    data :: Bokeh.Model.DataDict

    tags :: Vector{Any}
end

@model mutable struct SingleIntervalTicker <: iSingleIntervalTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    subscribed_events :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    interval :: Float64
end

@model mutable struct DaysTicker <: iDaysTicker

    syncable :: Bool = true

    interval :: Float64

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    days :: Vector{Int64} = Int64[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct HexTile <: iHexTile

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Float64 = 1.0

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    scale :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    orientation :: String = "pointytop"

    tags :: Vector{Any}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    aspect_scale :: Float64 = 1.0

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    r :: Bokeh.Model.Spec{Float64} = (field = "r",)

    q :: Bokeh.Model.Spec{Float64} = (field = "q",)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct WidgetBox <: iWidgetBox

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    spacing :: Int64 = 0

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    children :: Vector{iLayoutDOM}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct LinearScale <: iLinearScale

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Circle <: iCircle

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.SizeSpec = (value = 4.0,)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    hit_dilation :: Bokeh.Model.Size = 1.0

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    radius_dimension :: Bokeh.Model.EnumType{(:max, :min, :y, :x)} = :x

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    radius :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct FileInput <: iFileInput

    syncable :: Bool = true

    filename :: Bokeh.Model.ReadOnly{Union{String, Vector{String}}} = ""

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    multiple :: Bool = false

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    accept :: String = ""

    value :: Bokeh.Model.ReadOnly{Union{String, Vector{String}}} = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    mime_type :: Bokeh.Model.ReadOnly{Union{String, Vector{String}}} = ""

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct RedoTool <: iRedoTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct NodesAndLinkedEdges <: iNodesAndLinkedEdges

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CategoricalColorMapper <: iCategoricalColorMapper

    syncable :: Bool = true

    start :: Int64 = 0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    name :: Bokeh.Model.Nullable{String} = nothing

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    palette :: Vector{Bokeh.Model.Color}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MultiPolygons <: iMultiPolygons

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    ys :: Bokeh.Model.Spec{Float64} = (field = "ys",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    xs :: Bokeh.Model.Spec{Float64} = (field = "xs",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CumSum <: iCumSum

    syncable :: Bool = true

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    include_zero :: Bool = false

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Slider <: iSlider

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Float64}

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Float64

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tooltips :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    finish :: Float64

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Float64

    step :: Float64 = 1.0

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Patch <: iPatch

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    line_dash_offset :: Int64 = 0

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Size = 1.0

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MultiChoice <: iMultiChoice

    syncable :: Bool = true

    option_limit :: Bokeh.Model.Nullable{Int64} = nothing

    search_option_limit :: Bokeh.Model.Nullable{Int64} = nothing

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    solid :: Bool = true

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_items :: Bokeh.Model.Nullable{Int64} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    delete_button :: Bool = true

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    options :: Vector{Union{String, Tuple{String, String}}}

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    title :: String = ""

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Vector{String} = String[]

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Span <: iSpan

    syncable :: Bool = true

    location :: Bokeh.Model.Nullable{Float64} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    location_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    line_width :: Float64 = 1.0

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :width

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct BoxAnnotation <: iBoxAnnotation

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    hatch_scale :: Bokeh.Model.Size = 12.0

    hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    left :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_alpha :: Bokeh.Model.Percent = 1.0

    top :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    right_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    left_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.Percent = 1.0

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    bottom_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    right :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    line_width :: Float64 = 1.0

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    bottom :: Union{Nothing, Bokeh.Model.EnumType{(:auto,)}, Bokeh.Model.Spec{Float64}} = nothing

    line_dash_offset :: Int64 = 0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    hatch_weight :: Bokeh.Model.Size = 1.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.DashPattern

    top_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data
end

@model mutable struct TextAreaInput <: iTextAreaInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    value_input :: String = ""

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    max_length :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    cols :: Int64 = 20

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    rows :: Int64 = 2

    value :: String = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct GuideRenderer <: iGuideRenderer

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LinearAxis <: iLinearAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct AnnularWedge <: iAnnularWedge

    start_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    hatch_extra :: Dict{String, iTexture}

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    inner_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    finish_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    start_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    outer_radius :: Bokeh.Model.DistanceSpec = (field = "outer_radius",)

    outer_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    inner_radius :: Bokeh.Model.DistanceSpec = (field = "inner_radius",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}
end

@model mutable struct DomTemplate <: iDomTemplate

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    actions :: Vector{iAction}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct CategoricalTickFormatter <: iCategoricalTickFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DatetimeRangeSlider <: iDatetimeRangeSlider

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Tuple{Dates.DateTime, Dates.DateTime}}

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Dates.DateTime

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tooltips :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    finish :: Dates.DateTime

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Tuple{Dates.DateTime, Dates.DateTime}

    step :: Int64 = 3600000

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct NodeCoordinates <: iNodeCoordinates

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    layout :: iLayoutProvider

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct RangeTool <: iRangeTool

    syncable :: Bool = true

    y_range :: Bokeh.Model.Nullable{iRange1d} = nothing

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    y_interaction :: Bool = true

    tags :: Vector{Any}

    x_range :: Bokeh.Model.Nullable{iRange1d} = nothing

    x_interaction :: Bool = true

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct NumberEditor <: iNumberEditor

    syncable :: Bool = true

    step :: Float64 = 0.01

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct GMapPlot <: iGMapPlot

    syncable :: Bool = true

    min_border :: Bokeh.Model.Nullable{Int64} = 5

    border_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    map_options :: iGMapOptions

    outline_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    inner_width :: Bokeh.Model.ReadOnly{Int64} = 0

    x_range :: iRange = DataRange1d()

    above :: Vector{iRenderer}

    outer_width :: Bokeh.Model.ReadOnly{Int64} = 0

    inner_height :: Bokeh.Model.ReadOnly{Int64} = 0

    lod_interval :: Int64 = 300

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    min_border_top :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    outline_line_alpha :: Bokeh.Model.Percent = 1.0

    border_fill_alpha :: Bokeh.Model.Percent = 1.0

    below :: Vector{iRenderer}

    frame_width :: Bokeh.Model.Nullable{Int64} = nothing

    extra_y_ranges :: Dict{String, iRange}

    min_border_left :: Bokeh.Model.Nullable{Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    plot_height :: Bokeh.Model.Alias{:height}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    title_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :above

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    lod_factor :: Int64 = 10

    output_backend :: Bokeh.Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    extra_x_scales :: Dict{String, iScale}

    title :: Union{Nothing, iTitle} = Title()

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    right :: Vector{iRenderer}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    reset_policy :: Bokeh.Model.EnumType{(:standard, :event_only)} = :standard

    min_border_right :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    toolbar_sticky :: Bool = true

    y_range :: iRange = DataRange1d()

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    outline_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    outline_line_dash :: Bokeh.Model.DashPattern

    renderers :: Vector{iRenderer}

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    api_key :: Bokeh.Model.Base64String

    left :: Vector{iRenderer}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    hidpi :: Bool = true

    outer_height :: Bokeh.Model.ReadOnly{Int64} = 0

    subscribed_events :: Vector{String} = String[]

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    outline_line_dash_offset :: Int64 = 0

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    outline_line_width :: Float64 = 1.0

    match_aspect :: Bool = false

    extra_y_scales :: Dict{String, iScale}

    lod_threshold :: Bokeh.Model.Nullable{Int64} = 2000

    outline_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    frame_height :: Bokeh.Model.Nullable{Int64} = nothing

    y_scale :: iScale = LinearScale()

    disabled :: Bool = false

    aspect_scale :: Float64 = 1.0

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    api_version :: String = "weekly"

    lod_timeout :: Int64 = 500

    toolbar :: iToolbar = Toolbar()

    center :: Vector{iRenderer}

    toolbar_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :right

    min_border_bottom :: Bokeh.Model.Nullable{Int64} = nothing

    extra_x_ranges :: Dict{String, iRange}

    x_scale :: iScale = LinearScale()

    plot_width :: Bokeh.Model.Alias{:width}
end

@model mutable struct CrosshairTool <: iCrosshairTool

    syncable :: Bool = true

    line_color :: Bokeh.Model.Color = "rgb(0,0,0)"

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    toggleable :: Bool = true

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct BooleanFormatter <: iBooleanFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.EnumType{(Symbol("check-square-o"), Symbol("check-circle"), :check, Symbol("check-circle-o"), Symbol("check-square"))} = :check

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Ellipse <: iEllipse

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    height :: Bokeh.Model.DistanceSpec = (field = "height",)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    height_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    width_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.DistanceSpec = (field = "width",)
end

@model mutable struct BoxZoomTool <: iBoxZoomTool

    syncable :: Bool = true

    origin :: Bokeh.Model.EnumType{(:corner, :center)} = :corner

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    match_aspect :: Bool = false

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ColorMapper <: iColorMapper

    syncable :: Bool = true

    palette :: Vector{Bokeh.Model.Color}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"
end

@model mutable struct Arrow <: iArrow

    syncable :: Bool = true

    start_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    visible :: Bool = true

    start :: Bokeh.Model.Nullable{iArrowHead} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish :: Bokeh.Model.Nullable{iArrowHead} = OpenHead()

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    y_end :: Bokeh.Model.Spec{Float64} = (field = "y_end",)

    x_start :: Bokeh.Model.Spec{Float64} = (field = "x_start",)

    finish_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y_start :: Bokeh.Model.Spec{Float64} = (field = "y_start",)

    x_end :: Bokeh.Model.Spec{Float64} = (field = "x_end",)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    source :: iDataSource = ColumnDataSource()
end

@model mutable struct DomDiv <: iDomDiv

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct CanvasTexture <: iCanvasTexture

    syncable :: Bool = true

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    code :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Oval <: iOval

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    height :: Bokeh.Model.DistanceSpec = (field = "height",)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    height_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    width_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.DistanceSpec = (field = "width",)
end

@model mutable struct AllLabels <: iAllLabels

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct GeoJSONDataSource <: iGeoJSONDataSource

    syncable :: Bool = true

    geojson :: Bokeh.Model.JSONString

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    name :: Bokeh.Model.Nullable{String} = nothing

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MinAggregator <: iMinAggregator

    syncable :: Bool = true

    field_ :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomPlaceholder <: iDomPlaceholder

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Transform <: iTransform

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MaxAggregator <: iMaxAggregator

    syncable :: Bool = true

    field_ :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MathText <: iMathText

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    text :: String

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TileRenderer <: iTileRenderer

    syncable :: Bool = true

    alpha :: Float64 = 1.0

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    smoothing :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    tile_source :: iTileSource = WMTSTileSource()

    subscribed_events :: Vector{String} = String[]

    render_parents :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ImageURL <: iImageURL

    syncable :: Bool = true

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    h :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    retry_timeout :: Int64 = 0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    w :: Bokeh.Model.Nullable{Bokeh.Model.DistanceSpec} = nothing

    subscribed_events :: Vector{String} = String[]

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    url :: Bokeh.Model.Spec{String} = (field = "url",)

    dilate :: Bool = false

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    retry_attempts :: Int64 = 0

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    h_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    w_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    anchor :: Bokeh.Model.EnumType{(:right, :bottom_left, :top_center, :center_center, :center, :left, :center_left, :bottom, :top_right, :top, :bottom_center, :bottom_right, :top_left, :center_right)} = :top_left

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Glyph <: iGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct PreText <: iPreText

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    text :: String = ""

    disable_math :: Bool = false

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    style :: Dict{String, Any}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Dropdown <: iDropdown

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    label :: String = "Button"

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    split :: Bool = false

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.Nullable{iAbstractIcon} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    menu :: Vector{Union{Nothing, String, Tuple{String, Union{iCallback, String}}}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct AutocompleteInput <: iAutocompleteInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    value_input :: String = ""

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    max_length :: Bokeh.Model.Nullable{Int64} = nothing

    completions :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    case_sensitive :: Bool = true

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    restrict :: Bool = true

    value :: String = ""

    min_characters :: Bokeh.Model.PositiveInt = 2

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Ascii <: iAscii

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    text :: String

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct IndexFilter <: iIndexFilter

    syncable :: Bool = true

    indices :: Bokeh.Model.Nullable{Vector{Int64}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct LabelingPolicy <: iLabelingPolicy

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TileSource <: iTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Column <: iColumn

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    spacing :: Int64 = 0

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    children :: Vector{iLayoutDOM}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct PrintfTickFormatter <: iPrintfTickFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    format :: String = "%s"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CellEditor <: iCellEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CDSView <: iCDSView

    filters :: Vector{iFilter}

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    source :: iColumnarDataSource
end

@model mutable struct CustomJSExpr <: iCustomJSExpr

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{String, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ToolbarPanel <: iToolbarPanel

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    toolbar :: iToolbar

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Plot <: iPlot

    syncable :: Bool = true

    min_border :: Bokeh.Model.Nullable{Int64} = 5

    border_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    x_range :: iRange = DataRange1d()

    outline_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    inner_width :: Bokeh.Model.ReadOnly{Int64} = 0

    above :: Vector{iRenderer}

    outer_width :: Bokeh.Model.ReadOnly{Int64} = 0

    inner_height :: Bokeh.Model.ReadOnly{Int64} = 0

    lod_interval :: Int64 = 300

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    min_border_top :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    outline_line_alpha :: Bokeh.Model.Percent = 1.0

    border_fill_alpha :: Bokeh.Model.Percent = 1.0

    below :: Vector{iRenderer}

    frame_width :: Bokeh.Model.Nullable{Int64} = nothing

    extra_y_ranges :: Dict{String, iRange}

    min_border_left :: Bokeh.Model.Nullable{Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    plot_height :: Bokeh.Model.Alias{:height}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    title_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :above

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    lod_factor :: Int64 = 10

    output_backend :: Bokeh.Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    extra_x_scales :: Dict{String, iScale}

    title :: Union{Nothing, iTitle} = Title()

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    right :: Vector{iRenderer}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    reset_policy :: Bokeh.Model.EnumType{(:standard, :event_only)} = :standard

    min_border_right :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    toolbar_sticky :: Bool = true

    y_range :: iRange = DataRange1d()

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    outline_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    outline_line_dash :: Bokeh.Model.DashPattern

    renderers :: Vector{iRenderer}

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    left :: Vector{iRenderer}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    hidpi :: Bool = true

    outer_height :: Bokeh.Model.ReadOnly{Int64} = 0

    subscribed_events :: Vector{String} = String[]

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    outline_line_dash_offset :: Int64 = 0

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    outline_line_width :: Float64 = 1.0

    match_aspect :: Bool = false

    extra_y_scales :: Dict{String, iScale}

    lod_threshold :: Bokeh.Model.Nullable{Int64} = 2000

    outline_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    frame_height :: Bokeh.Model.Nullable{Int64} = nothing

    y_scale :: iScale = LinearScale()

    disabled :: Bool = false

    aspect_scale :: Float64 = 1.0

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    lod_timeout :: Int64 = 500

    toolbar :: iToolbar = Toolbar()

    center :: Vector{iRenderer}

    toolbar_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :right

    min_border_bottom :: Bokeh.Model.Nullable{Int64} = nothing

    extra_x_ranges :: Dict{String, iRange}

    x_scale :: iScale = LinearScale()

    plot_width :: Bokeh.Model.Alias{:width}
end

@model mutable struct Callback <: iCallback

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CustomJSTransform <: iCustomJSTransform

    syncable :: Bool = true

    v_func :: String = ""

    args :: Dict{String, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    func :: String = ""

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct NumberFormatter <: iNumberFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    format :: String = "0,0"

    rounding :: Bokeh.Model.EnumType{(:rounddown, :round, :nearest, :floor, :ceil, :roundup)} = :round

    language :: Bokeh.Model.EnumType{(Symbol("da-dk"), :de, :en, :th, :chs, Symbol("fr-ch"), :pl, :tr, Symbol("pt-pt"), Symbol("es-ES"), :fr, Symbol("pt-br"), :es, Symbol("en-gb"), :ja, :hu, Symbol("fr-CA"), Symbol("de-ch"), Symbol("nl-nl"), :it, :ru, Symbol("ru-UA"), :fi, Symbol("be-nl"), :cs, :et, :sk, Symbol("uk-UA"))} = :en

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ContinuousColorMapper <: iContinuousColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Range1d <: iRange1d

    syncable :: Bool = true

    reset_end :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    start :: Union{Float64, Dates.DateTime, Dates.Period} = 0.0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    finish :: Union{Float64, Dates.DateTime, Dates.Period} = 1.0

    name :: Bokeh.Model.Nullable{String} = nothing

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    reset_start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PolarTransform <: iPolarTransform

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "angle",)

    name :: Bokeh.Model.Nullable{String} = nothing

    radius :: Bokeh.Model.Spec{Float64} = (field = "radius",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct VeeHead <: iVeeHead

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MapPlot <: iMapPlot

    syncable :: Bool = true

    min_border :: Bokeh.Model.Nullable{Int64} = 5

    border_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    x_range :: iRange = DataRange1d()

    outline_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    inner_width :: Bokeh.Model.ReadOnly{Int64} = 0

    above :: Vector{iRenderer}

    outer_width :: Bokeh.Model.ReadOnly{Int64} = 0

    inner_height :: Bokeh.Model.ReadOnly{Int64} = 0

    lod_interval :: Int64 = 300

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    min_border_top :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    outline_line_alpha :: Bokeh.Model.Percent = 1.0

    border_fill_alpha :: Bokeh.Model.Percent = 1.0

    below :: Vector{iRenderer}

    frame_width :: Bokeh.Model.Nullable{Int64} = nothing

    extra_y_ranges :: Dict{String, iRange}

    min_border_left :: Bokeh.Model.Nullable{Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    plot_height :: Bokeh.Model.Alias{:height}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    title_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :above

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    lod_factor :: Int64 = 10

    output_backend :: Bokeh.Model.EnumType{(:svg, :canvas, :webgl)} = :canvas

    extra_x_scales :: Dict{String, iScale}

    title :: Union{Nothing, iTitle} = Title()

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    right :: Vector{iRenderer}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    reset_policy :: Bokeh.Model.EnumType{(:standard, :event_only)} = :standard

    min_border_right :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    toolbar_sticky :: Bool = true

    y_range :: iRange = DataRange1d()

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    outline_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    outline_line_dash :: Bokeh.Model.DashPattern

    renderers :: Vector{iRenderer}

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    left :: Vector{iRenderer}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    hidpi :: Bool = true

    outer_height :: Bokeh.Model.ReadOnly{Int64} = 0

    subscribed_events :: Vector{String} = String[]

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    outline_line_dash_offset :: Int64 = 0

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    outline_line_width :: Float64 = 1.0

    match_aspect :: Bool = false

    extra_y_scales :: Dict{String, iScale}

    lod_threshold :: Bokeh.Model.Nullable{Int64} = 2000

    outline_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    frame_height :: Bokeh.Model.Nullable{Int64} = nothing

    y_scale :: iScale = LinearScale()

    disabled :: Bool = false

    aspect_scale :: Float64 = 1.0

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    lod_timeout :: Int64 = 500

    toolbar :: iToolbar = Toolbar()

    center :: Vector{iRenderer}

    toolbar_location :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:below, :left, :right, :above)}} = :right

    min_border_bottom :: Bokeh.Model.Nullable{Int64} = nothing

    extra_x_ranges :: Dict{String, iRange}

    x_scale :: iScale = LinearScale()

    plot_width :: Bokeh.Model.Alias{:width}
end

@model mutable struct LinearColorMapper <: iLinearColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Selection <: iSelection

    syncable :: Bool = true

    indices :: Vector{Int64} = Int64[]

    multiline_indices :: Dict{String, Vector{Int64}}

    line_indices :: Vector{Int64} = Int64[]

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct AbstractSlider <: iAbstractSlider

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tooltips :: Bool = true

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Step <: iStep

    syncable :: Bool = true

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :before

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    line_dash_offset :: Int64 = 0

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Spinner <: iSpinner

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Union{Nothing, Float64, Int64}} = nothing

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    page_step_multiplier :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    mode :: Bokeh.Model.EnumType{(:int, :float)} = :int

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    wheel_wait :: Union{Float64, Int64} = 100

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{Nothing, iTickFormatter, String} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Union{Nothing, Float64, Int64} = nothing

    high :: Union{Nothing, Float64, Int64} = nothing

    step :: Bokeh.Model.Interval = Bokeh.Model.Unknown()

    low :: Union{Nothing, Float64, Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Minimum <: iMinimum

    syncable :: Bool = true

    field :: String

    initial :: Bokeh.Model.Nullable{Float64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct HatchGlyph <: iHatchGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Tool <: iTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomTable <: iDomTable

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct RadioButtonGroup <: iRadioButtonGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct TextGlyph <: iTextGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CompositeTicker <: iCompositeTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    subscribed_events :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tickers :: Vector{iTicker}

    tags :: Vector{Any}
end

@model mutable struct Band <: iBand

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.Percent = 1.0

    fill_alpha :: Bokeh.Model.Percent = 1.0

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    line_width :: Float64 = 1.0

    x_range_name :: String = "default"

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()
end

@model mutable struct Ray <: iRay

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    length_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    length :: Bokeh.Model.DistanceSpec = (value = 0.0,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ArrowHead <: iArrowHead

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct UnionRenderers <: iUnionRenderers

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct BasicTickFormatter <: iBasicTickFormatter

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    precision :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    power_limit_low :: Int64 = -3

    subscribed_events :: Vector{String} = String[]

    use_scientific :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    power_limit_high :: Int64 = 5

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LineEditTool <: iLineEditTool

    syncable :: Bool = true

    intersection_renderer :: iGlyphRenderer

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Title <: iTitle

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    text_font :: String = "helvetica"

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    text_color :: Bokeh.Model.Color = "rgb(68,68,68)"

    text_alpha :: Bokeh.Model.Percent = 1.0

    text :: String = ""

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    border_line_dash_offset :: Int64 = 0

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    text_line_height :: Float64 = 1.0

    name :: Bokeh.Model.Nullable{String} = nothing

    standoff :: Float64 = 10.0

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :bold

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    offset :: Float64 = 0.0

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    text_font_size :: String = "13px"

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    vertical_align :: Bokeh.Model.EnumType{(:middle, :bottom, :top)} = :bottom

    border_line_width :: Float64 = 1.0

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    border_line_dash :: Bokeh.Model.DashPattern
end

@model mutable struct RendererGroup <: iRendererGroup

    syncable :: Bool = true

    visible :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CategoricalMarkerMapper <: iCategoricalMarkerMapper

    syncable :: Bool = true

    markers :: Vector{Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    start :: Int64 = 0

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    default_value :: Bokeh.Model.EnumType{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = :circle

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct InspectTool <: iInspectTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    toggleable :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Mapper <: iMapper

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomToggleGroup <: iDomToggleGroup

    syncable :: Bool = true

    groups :: Vector{iRendererGroup}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct FixedTicker <: iFixedTicker

    syncable :: Bool = true

    ticks :: Vector{Float64} = Float64[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    minor_ticks :: Vector{Float64} = Float64[]

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PasswordInput <: iPasswordInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    value_input :: String = ""

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    max_length :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: String = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct ServerSentDataSource <: iServerSentDataSource

    syncable :: Bool = true

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.DataDict

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()

    data_url :: String

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct QUADKEYTileSource <: iQUADKEYTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    snap_to_zoom :: Bool = false

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    wrap_around :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CheckboxButtonGroup <: iCheckboxButtonGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Vector{Int64} = Int64[]

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Paragraph <: iParagraph

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    text :: String = ""

    disable_math :: Bool = false

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    style :: Dict{String, Any}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct LogTicker <: iLogTicker

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    desired_num_ticks :: Int64 = 6

    base :: Float64 = 10.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct EdgeCoordinates <: iEdgeCoordinates

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    layout :: iLayoutProvider

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CategoricalAxis <: iCategoricalAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    group_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical, :parallel, :normal)}} = :parallel

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    group_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    separator_line_dash :: Bokeh.Model.DashPattern

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    subgroup_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    subgroup_text_alpha :: Bokeh.Model.Percent = 1.0

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    group_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    group_text_font_size :: Bokeh.Model.FontSize = "16px"

    group_text_line_height :: Float64 = 1.2

    separator_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    group_text_alpha :: Bokeh.Model.Percent = 1.0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_tick_out :: Int64 = 6

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    separator_line_width :: Float64 = 1.0

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    subgroup_text_font :: String = "helvetica"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    group_text_font :: String = "helvetica"

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    subgroup_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical, :parallel, :normal)}} = :parallel

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    subgroup_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    subgroup_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    group_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    separator_line_dash_offset :: Int64 = 0

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    subgroup_text_font_size :: Bokeh.Model.FontSize = "16px"

    separator_line_alpha :: Bokeh.Model.Percent = 1.0

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    separator_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    subgroup_text_line_height :: Float64 = 1.2

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash_offset :: Int64 = 0

    group_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    subgroup_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    separator_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct CellFormatter <: iCellFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Styles <: iStyles

    background_color :: Bokeh.Model.Nullable{String} = nothing

    mask_composite :: Bokeh.Model.Nullable{String} = nothing

    alignment_baseline :: Bokeh.Model.Nullable{String} = nothing

    font_stretch :: Bokeh.Model.Nullable{String} = nothing

    overflow_y :: Bokeh.Model.Nullable{String} = nothing

    border_color :: Bokeh.Model.Nullable{String} = nothing

    row_gap :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_inline :: Bokeh.Model.Nullable{String} = nothing

    padding_right :: Bokeh.Model.Nullable{String} = nothing

    transition_delay :: Bokeh.Model.Nullable{String} = nothing

    background_attachment :: Bokeh.Model.Nullable{String} = nothing

    column_rule :: Bokeh.Model.Nullable{String} = nothing

    border_width :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_color :: Bokeh.Model.Nullable{String} = nothing

    mask :: Bokeh.Model.Nullable{String} = nothing

    clip_rule :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_style :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    flood_color :: Bokeh.Model.Nullable{String} = nothing

    overflow :: Bokeh.Model.Nullable{String} = nothing

    marker_end :: Bokeh.Model.Nullable{String} = nothing

    border_spacing :: Bokeh.Model.Nullable{String} = nothing

    min_inline_size :: Bokeh.Model.Nullable{String} = nothing

    object_position :: Bokeh.Model.Nullable{String} = nothing

    right :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_width :: Bokeh.Model.Nullable{String} = nothing

    background_position_x :: Bokeh.Model.Nullable{String} = nothing

    font_size :: Bokeh.Model.Nullable{String} = nothing

    color :: Bokeh.Model.Nullable{String} = nothing

    grid_row_end :: Bokeh.Model.Nullable{String} = nothing

    bottom :: Bokeh.Model.Nullable{String} = nothing

    font_variant_ligatures :: Bokeh.Model.Nullable{String} = nothing

    mask_position :: Bokeh.Model.Nullable{String} = nothing

    backface_visibility :: Bokeh.Model.Nullable{String} = nothing

    text_indent :: Bokeh.Model.Nullable{String} = nothing

    css_float :: Bokeh.Model.Nullable{String} = nothing

    font_style :: Bokeh.Model.Nullable{String} = nothing

    font_weight :: Bokeh.Model.Nullable{String} = nothing

    min_block_size :: Bokeh.Model.Nullable{String} = nothing

    text_decoration :: Bokeh.Model.Nullable{String} = nothing

    text_underline_position :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_style :: Bokeh.Model.Nullable{String} = nothing

    justify_items :: Bokeh.Model.Nullable{String} = nothing

    page_break_before :: Bokeh.Model.Nullable{String} = nothing

    border_right_width :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_line :: Bokeh.Model.Nullable{String} = nothing

    ruby_align :: Bokeh.Model.Nullable{String} = nothing

    background_image :: Bokeh.Model.Nullable{String} = nothing

    align_items :: Bokeh.Model.Nullable{String} = nothing

    paint_order :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_rows :: Bokeh.Model.Nullable{String} = nothing

    flex_grow :: Bokeh.Model.Nullable{String} = nothing

    css_text :: Bokeh.Model.Nullable{String} = nothing

    vertical_align :: Bokeh.Model.Nullable{String} = nothing

    justify_content :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_color :: Bokeh.Model.Nullable{String} = nothing

    outline :: Bokeh.Model.Nullable{String} = nothing

    border_image :: Bokeh.Model.Nullable{String} = nothing

    widows :: Bokeh.Model.Nullable{String} = nothing

    stroke_width :: Bokeh.Model.Nullable{String} = nothing

    margin_right :: Bokeh.Model.Nullable{String} = nothing

    top :: Bokeh.Model.Nullable{String} = nothing

    fill_rule :: Bokeh.Model.Nullable{String} = nothing

    grid_row_gap :: Bokeh.Model.Nullable{String} = nothing

    user_select :: Bokeh.Model.Nullable{String} = nothing

    flood_opacity :: Bokeh.Model.Nullable{String} = nothing

    border_left :: Bokeh.Model.Nullable{String} = nothing

    margin_left :: Bokeh.Model.Nullable{String} = nothing

    clip_path :: Bokeh.Model.Nullable{String} = nothing

    line_height :: Bokeh.Model.Nullable{String} = nothing

    rotate :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start :: Bokeh.Model.Nullable{String} = nothing

    flex_shrink :: Bokeh.Model.Nullable{String} = nothing

    line_break :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end :: Bokeh.Model.Nullable{String} = nothing

    font_kerning :: Bokeh.Model.Nullable{String} = nothing

    border_top_width :: Bokeh.Model.Nullable{String} = nothing

    border_collapse :: Bokeh.Model.Nullable{String} = nothing

    transform_style :: Bokeh.Model.Nullable{String} = nothing

    grid_gap :: Bokeh.Model.Nullable{String} = nothing

    syncable :: Bool = true

    font_variant_numeric :: Bokeh.Model.Nullable{String} = nothing

    height :: Bokeh.Model.Nullable{String} = nothing

    tab_size :: Bokeh.Model.Nullable{String} = nothing

    stroke_dasharray :: Bokeh.Model.Nullable{String} = nothing

    filter :: Bokeh.Model.Nullable{String} = nothing

    flex_direction :: Bokeh.Model.Nullable{String} = nothing

    touch_action :: Bokeh.Model.Nullable{String} = nothing

    animation_duration :: Bokeh.Model.Nullable{String} = nothing

    padding_inline_start :: Bokeh.Model.Nullable{String} = nothing

    border_block_end :: Bokeh.Model.Nullable{String} = nothing

    border_top_right_radius :: Bokeh.Model.Nullable{String} = nothing

    padding_block_end :: Bokeh.Model.Nullable{String} = nothing

    shape_rendering :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{String} = nothing

    column_fill :: Bokeh.Model.Nullable{String} = nothing

    gap :: Bokeh.Model.Nullable{String} = nothing

    break_inside :: Bokeh.Model.Nullable{String} = nothing

    border_left_style :: Bokeh.Model.Nullable{String} = nothing

    padding_block_start :: Bokeh.Model.Nullable{String} = nothing

    page_break_after :: Bokeh.Model.Nullable{String} = nothing

    border_top_left_radius :: Bokeh.Model.Nullable{String} = nothing

    margin :: Bokeh.Model.Nullable{String} = nothing

    text_rendering :: Bokeh.Model.Nullable{String} = nothing

    column_span :: Bokeh.Model.Nullable{String} = nothing

    border_image_slice :: Bokeh.Model.Nullable{String} = nothing

    background_clip :: Bokeh.Model.Nullable{String} = nothing

    columns :: Bokeh.Model.Nullable{String} = nothing

    transition_property :: Bokeh.Model.Nullable{String} = nothing

    animation_direction :: Bokeh.Model.Nullable{String} = nothing

    grid_column :: Bokeh.Model.Nullable{String} = nothing

    font_feature_settings :: Bokeh.Model.Nullable{String} = nothing

    clip :: Bokeh.Model.Nullable{String} = nothing

    outline_width :: Bokeh.Model.Nullable{String} = nothing

    flex_basis :: Bokeh.Model.Nullable{String} = nothing

    mask_repeat :: Bokeh.Model.Nullable{String} = nothing

    border_right_style :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior :: Bokeh.Model.Nullable{String} = nothing

    margin_bottom :: Bokeh.Model.Nullable{String} = nothing

    box_sizing :: Bokeh.Model.Nullable{String} = nothing

    content :: Bokeh.Model.Nullable{String} = nothing

    font_family :: Bokeh.Model.Nullable{String} = nothing

    break_after :: Bokeh.Model.Nullable{String} = nothing

    text_shadow :: Bokeh.Model.Nullable{String} = nothing

    border_style :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_style :: Bokeh.Model.Nullable{String} = nothing

    scroll_behavior :: Bokeh.Model.Nullable{String} = nothing

    left :: Bokeh.Model.Nullable{String} = nothing

    animation :: Bokeh.Model.Nullable{String} = nothing

    overflow_wrap :: Bokeh.Model.Nullable{String} = nothing

    stroke_miterlimit :: Bokeh.Model.Nullable{String} = nothing

    background_position_y :: Bokeh.Model.Nullable{String} = nothing

    animation_iteration_count :: Bokeh.Model.Nullable{String} = nothing

    resize :: Bokeh.Model.Nullable{String} = nothing

    cursor :: Bokeh.Model.Nullable{String} = nothing

    stroke :: Bokeh.Model.Nullable{String} = nothing

    quotes :: Bokeh.Model.Nullable{String} = nothing

    image_orientation :: Bokeh.Model.Nullable{String} = nothing

    list_style_image :: Bokeh.Model.Nullable{String} = nothing

    grid_column_end :: Bokeh.Model.Nullable{String} = nothing

    margin_block_start :: Bokeh.Model.Nullable{String} = nothing

    transition_duration :: Bokeh.Model.Nullable{String} = nothing

    marker_mid :: Bokeh.Model.Nullable{String} = nothing

    font :: Bokeh.Model.Nullable{String} = nothing

    text_align_last :: Bokeh.Model.Nullable{String} = nothing

    place_content :: Bokeh.Model.Nullable{String} = nothing

    break_before :: Bokeh.Model.Nullable{String} = nothing

    padding_top :: Bokeh.Model.Nullable{String} = nothing

    grid_template_rows :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_columns :: Bokeh.Model.Nullable{String} = nothing

    marker :: Bokeh.Model.Nullable{String} = nothing

    box_shadow :: Bokeh.Model.Nullable{String} = nothing

    column_width :: Bokeh.Model.Nullable{String} = nothing

    border_block_start :: Bokeh.Model.Nullable{String} = nothing

    word_spacing :: Bokeh.Model.Nullable{String} = nothing

    font_variant_position :: Bokeh.Model.Nullable{String} = nothing

    fill :: Bokeh.Model.Nullable{String} = nothing

    animation_delay :: Bokeh.Model.Nullable{String} = nothing

    background_position :: Bokeh.Model.Nullable{String} = nothing

    border_top :: Bokeh.Model.Nullable{String} = nothing

    hyphens :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_style :: Bokeh.Model.Nullable{String} = nothing

    color_interpolation_filters :: Bokeh.Model.Nullable{String} = nothing

    ruby_position :: Bokeh.Model.Nullable{String} = nothing

    align_self :: Bokeh.Model.Nullable{String} = nothing

    pointer_events :: Bokeh.Model.Nullable{String} = nothing

    all :: Bokeh.Model.Nullable{String} = nothing

    orphans :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_style :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_block :: Bokeh.Model.Nullable{String} = nothing

    clear :: Bokeh.Model.Nullable{String} = nothing

    border_inline_start_width :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    column_rule_width :: Bokeh.Model.Nullable{String} = nothing

    grid_row :: Bokeh.Model.Nullable{String} = nothing

    margin_inline_end :: Bokeh.Model.Nullable{String} = nothing

    page_break_inside :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis :: Bokeh.Model.Nullable{String} = nothing

    column_rule_style :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_left_radius :: Bokeh.Model.Nullable{String} = nothing

    grid_column_start :: Bokeh.Model.Nullable{String} = nothing

    place_items :: Bokeh.Model.Nullable{String} = nothing

    grid_auto_flow :: Bokeh.Model.Nullable{String} = nothing

    list_style :: Bokeh.Model.Nullable{String} = nothing

    grid_area :: Bokeh.Model.Nullable{String} = nothing

    transition_timing_function :: Bokeh.Model.Nullable{String} = nothing

    text_justify :: Bokeh.Model.Nullable{String} = nothing

    margin_inline_start :: Bokeh.Model.Nullable{String} = nothing

    flex :: Bokeh.Model.Nullable{String} = nothing

    perspective :: Bokeh.Model.Nullable{String} = nothing

    border_image_outset :: Bokeh.Model.Nullable{String} = nothing

    font_variant :: Bokeh.Model.Nullable{String} = nothing

    max_height :: Bokeh.Model.Nullable{String} = nothing

    font_variant_east_asian :: Bokeh.Model.Nullable{String} = nothing

    padding_left :: Bokeh.Model.Nullable{String} = nothing

    stroke_linecap :: Bokeh.Model.Nullable{String} = nothing

    transform :: Bokeh.Model.Nullable{String} = nothing

    glyph_orientation_vertical :: Bokeh.Model.Nullable{String} = nothing

    margin_block_end :: Bokeh.Model.Nullable{String} = nothing

    white_space :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_color :: Bokeh.Model.Nullable{String} = nothing

    stroke_dashoffset :: Bokeh.Model.Nullable{String} = nothing

    stop_opacity :: Bokeh.Model.Nullable{String} = nothing

    border_block_start_color :: Bokeh.Model.Nullable{String} = nothing

    min_width :: Bokeh.Model.Nullable{String} = nothing

    empty_cells :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_y :: Bokeh.Model.Nullable{String} = nothing

    border_image_source :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    transform_box :: Bokeh.Model.Nullable{String} = nothing

    max_width :: Bokeh.Model.Nullable{String} = nothing

    will_change :: Bokeh.Model.Nullable{String} = nothing

    column_count :: Bokeh.Model.Nullable{String} = nothing

    float :: Bokeh.Model.Nullable{String} = nothing

    display :: Bokeh.Model.Nullable{String} = nothing

    animation_timing_function :: Bokeh.Model.Nullable{String} = nothing

    padding :: Bokeh.Model.Nullable{String} = nothing

    grid :: Bokeh.Model.Nullable{String} = nothing

    grid_template_columns :: Bokeh.Model.Nullable{String} = nothing

    flex_flow :: Bokeh.Model.Nullable{String} = nothing

    caret_color :: Bokeh.Model.Nullable{String} = nothing

    max_inline_size :: Bokeh.Model.Nullable{String} = nothing

    direction :: Bokeh.Model.Nullable{String} = nothing

    stroke_linejoin :: Bokeh.Model.Nullable{String} = nothing

    width :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_right_radius :: Bokeh.Model.Nullable{String} = nothing

    mask_type :: Bokeh.Model.Nullable{String} = nothing

    grid_template_areas :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_color :: Bokeh.Model.Nullable{String} = nothing

    justify_self :: Bokeh.Model.Nullable{String} = nothing

    table_layout :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_color :: Bokeh.Model.Nullable{String} = nothing

    border_block_end_width :: Bokeh.Model.Nullable{String} = nothing

    border_left_width :: Bokeh.Model.Nullable{String} = nothing

    word_break :: Bokeh.Model.Nullable{String} = nothing

    writing_mode :: Bokeh.Model.Nullable{String} = nothing

    mask_size :: Bokeh.Model.Nullable{String} = nothing

    padding_inline_end :: Bokeh.Model.Nullable{String} = nothing

    animation_name :: Bokeh.Model.Nullable{String} = nothing

    text_anchor :: Bokeh.Model.Nullable{String} = nothing

    background_size :: Bokeh.Model.Nullable{String} = nothing

    text_transform :: Bokeh.Model.Nullable{String} = nothing

    stop_color :: Bokeh.Model.Nullable{String} = nothing

    margin_top :: Bokeh.Model.Nullable{String} = nothing

    animation_fill_mode :: Bokeh.Model.Nullable{String} = nothing

    baseline_shift :: Bokeh.Model.Nullable{String} = nothing

    outline_color :: Bokeh.Model.Nullable{String} = nothing

    text_orientation :: Bokeh.Model.Nullable{String} = nothing

    outline_style :: Bokeh.Model.Nullable{String} = nothing

    max_block_size :: Bokeh.Model.Nullable{String} = nothing

    border_right :: Bokeh.Model.Nullable{String} = nothing

    background_repeat :: Bokeh.Model.Nullable{String} = nothing

    list_style_type :: Bokeh.Model.Nullable{String} = nothing

    font_size_adjust :: Bokeh.Model.Nullable{String} = nothing

    word_wrap :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_style :: Bokeh.Model.Nullable{String} = nothing

    translate :: Bokeh.Model.Nullable{String} = nothing

    inline_size :: Bokeh.Model.Nullable{String} = nothing

    opacity :: Bokeh.Model.Nullable{String} = nothing

    caption_side :: Bokeh.Model.Nullable{String} = nothing

    letter_spacing :: Bokeh.Model.Nullable{String} = nothing

    background_origin :: Bokeh.Model.Nullable{String} = nothing

    text_emphasis_position :: Bokeh.Model.Nullable{String} = nothing

    place_self :: Bokeh.Model.Nullable{String} = nothing

    marker_start :: Bokeh.Model.Nullable{String} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    flex_wrap :: Bokeh.Model.Nullable{String} = nothing

    min_height :: Bokeh.Model.Nullable{String} = nothing

    position :: Bokeh.Model.Nullable{String} = nothing

    text_overflow :: Bokeh.Model.Nullable{String} = nothing

    text_decoration_color :: Bokeh.Model.Nullable{String} = nothing

    mask_image :: Bokeh.Model.Nullable{String} = nothing

    scale :: Bokeh.Model.Nullable{String} = nothing

    border_bottom :: Bokeh.Model.Nullable{String} = nothing

    color_interpolation :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_width :: Bokeh.Model.Nullable{String} = nothing

    stroke_opacity :: Bokeh.Model.Nullable{String} = nothing

    visibility :: Bokeh.Model.Nullable{String} = nothing

    column_rule_color :: Bokeh.Model.Nullable{String} = nothing

    align_content :: Bokeh.Model.Nullable{String} = nothing

    z_index :: Bokeh.Model.Nullable{String} = nothing

    unicode_bidi :: Bokeh.Model.Nullable{String} = nothing

    border_left_color :: Bokeh.Model.Nullable{String} = nothing

    object_fit :: Bokeh.Model.Nullable{String} = nothing

    counter_reset :: Bokeh.Model.Nullable{String} = nothing

    border_image_width :: Bokeh.Model.Nullable{String} = nothing

    perspective_origin :: Bokeh.Model.Nullable{String} = nothing

    border_right_color :: Bokeh.Model.Nullable{String} = nothing

    font_variant_caps :: Bokeh.Model.Nullable{String} = nothing

    border_bottom_style :: Bokeh.Model.Nullable{String} = nothing

    overscroll_behavior_x :: Bokeh.Model.Nullable{String} = nothing

    tags :: Vector{Any}

    text_combine_upright :: Bokeh.Model.Nullable{String} = nothing

    dominant_baseline :: Bokeh.Model.Nullable{String} = nothing

    overflow_anchor :: Bokeh.Model.Nullable{String} = nothing

    outline_offset :: Bokeh.Model.Nullable{String} = nothing

    overflow_x :: Bokeh.Model.Nullable{String} = nothing

    column_gap :: Bokeh.Model.Nullable{String} = nothing

    animation_play_state :: Bokeh.Model.Nullable{String} = nothing

    border_top_style :: Bokeh.Model.Nullable{String} = nothing

    border_image_repeat :: Bokeh.Model.Nullable{String} = nothing

    font_synthesis :: Bokeh.Model.Nullable{String} = nothing

    grid_column_gap :: Bokeh.Model.Nullable{String} = nothing

    transition :: Bokeh.Model.Nullable{String} = nothing

    grid_template :: Bokeh.Model.Nullable{String} = nothing

    image_rendering :: Bokeh.Model.Nullable{String} = nothing

    border_inline_end_width :: Bokeh.Model.Nullable{String} = nothing

    counter_increment :: Bokeh.Model.Nullable{String} = nothing

    lighting_color :: Bokeh.Model.Nullable{String} = nothing

    order :: Bokeh.Model.Nullable{String} = nothing

    border_top_color :: Bokeh.Model.Nullable{String} = nothing

    border_radius :: Bokeh.Model.Nullable{String} = nothing

    grid_row_start :: Bokeh.Model.Nullable{String} = nothing

    padding_bottom :: Bokeh.Model.Nullable{String} = nothing

    transform_origin :: Bokeh.Model.Nullable{String} = nothing

    list_style_position :: Bokeh.Model.Nullable{String} = nothing

    block_size :: Bokeh.Model.Nullable{String} = nothing

    border :: Bokeh.Model.Nullable{String} = nothing

    fill_opacity :: Bokeh.Model.Nullable{String} = nothing

    text_align :: Bokeh.Model.Nullable{String} = nothing
end

@model mutable struct SelectionPolicy <: iSelectionPolicy

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Expression <: iExpression

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TimeEditor <: iTimeEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct SaveTool <: iSaveTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct BaseText <: iBaseText

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    text :: String

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DatetimeAxis <: iDatetimeAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct LinearInterpolator <: iLinearInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    clip :: Bool = true

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.Nullable{iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DomValueRef <: iDomValueRef

    syncable :: Bool = true

    field :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ToolbarBox <: iToolbarBox

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    toolbar :: iToolbarBase

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    toolbar_location :: Bokeh.Model.EnumType{(:below, :left, :right, :above)} = :right

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct CheckboxEditor <: iCheckboxEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Image <: iImage

    syncable :: Bool = true

    global_alpha :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    dw :: Bokeh.Model.DistanceSpec = (field = "dw",)

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    dilate :: Bool = false

    image :: Bokeh.Model.Spec{Float64} = (field = "image",)

    dh_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    name :: Bokeh.Model.Nullable{String} = nothing

    color_mapper :: iColorMapper = LinearColorMapper()

    dw_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    dh :: Bokeh.Model.DistanceSpec = (field = "dh",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct VBar <: iVBar

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    top :: Bokeh.Model.Spec{Float64} = (field = "top",)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    bottom :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)
end

@model mutable struct DataSource <: iDataSource

    syncable :: Bool = true

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ActionTool <: iActionTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct LineGlyph <: iLineGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DomDOMElement <: iDomDOMElement

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct Renderer <: iRenderer

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Tooltip <: iTooltip

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    inner_only :: Bool = true

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    show_arrow :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    attachment :: Bokeh.Model.EnumType{(:left, :right, :below, :vertical, :horizontal, :above)} = :horizontal
end

@model mutable struct DomTableRow <: iDomTableRow

    syncable :: Bool = true

    children :: Vector{Union{iDOMNode, iLayoutDOM, String}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    style :: Bokeh.Model.Nullable{Union{iStyles, Dict{String, String}}} = nothing
end

@model mutable struct Group <: iGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    inline :: Bool = false

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Quad <: iQuad

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    left :: Bokeh.Model.Spec{Float64} = (field = "left",)

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    top :: Bokeh.Model.Spec{Float64} = (field = "top",)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    right :: Bokeh.Model.Spec{Float64} = (field = "right",)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    bottom :: Bokeh.Model.Spec{Float64} = (field = "bottom",)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}
end

@model mutable struct Interpolator <: iInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    clip :: Bool = true

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.Nullable{iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Panel <: iPanel

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    closable :: Bool = false

    child :: iLayoutDOM

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MercatorTileSource <: iMercatorTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    snap_to_zoom :: Bool = false

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    wrap_around :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct UndoTool <: iUndoTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Toggle <: iToggle

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Bool = false

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    label :: String = "Button"

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.Nullable{iAbstractIcon} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Tap <: iTap

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CoordinateMapping <: iCoordinateMapping

    syncable :: Bool = true

    x_target :: iRange

    y_scale :: iScale = LinearScale()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    y_source :: iRange = DataRange1d()

    y_target :: iRange

    name :: Bokeh.Model.Nullable{String} = nothing

    x_source :: iRange = DataRange1d()

    x_scale :: iScale = LinearScale()

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Axis <: iAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct DataModel <: iDataModel

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Arc <: iArc

    syncable :: Bool = true

    start_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "start_angle",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    finish_angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (field = "end_angle",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    finish_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    start_angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    radius :: Bokeh.Model.DistanceSpec = (field = "radius",)

    direction :: Bokeh.Model.EnumType{(:clock, :anticlock)} = :anticlock

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DataRange <: iDataRange

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iModel}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    names :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct XYComponent <: iXYComponent

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    transform :: iCoordinateTransform

    tags :: Vector{Any}
end

@model mutable struct ScientificFormatter <: iScientificFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    precision :: Int64 = 10

    power_limit_low :: Int64 = -3

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    power_limit_high :: Int64 = 5

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct VArea <: iVArea

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    name :: Bokeh.Model.Nullable{String} = nothing

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    y1 :: Bokeh.Model.Spec{Float64} = (field = "y1",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    y2 :: Bokeh.Model.Spec{Float64} = (field = "y2",)
end

@model mutable struct NoOverlap <: iNoOverlap

    syncable :: Bool = true

    min_distance :: Int64 = 5

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct AbstractButton <: iAbstractButton

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    label :: String = "Button"

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.Nullable{iAbstractIcon} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct MathML <: iMathML

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    text :: String

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct BasicTicker <: iBasicTicker

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    desired_num_ticks :: Int64 = 6

    base :: Float64 = 10.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct GraphRenderer <: iGraphRenderer

    layout_provider :: iLayoutProvider

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    edge_renderer :: iGlyphRenderer = GlyphRenderer()

    inspection_policy :: iGraphHitTestPolicy = NodesOnly()

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    node_renderer :: iGlyphRenderer = GlyphRenderer()

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    selection_policy :: iGraphHitTestPolicy = NodesOnly()

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Maximum <: iMaximum

    syncable :: Bool = true

    field :: String

    initial :: Bokeh.Model.Nullable{Float64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct TickFormatter <: iTickFormatter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DatePicker <: iDatePicker

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    position :: Bokeh.Model.EnumType{(:below, :auto, :above)} = :auto

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    min_date :: Bokeh.Model.Nullable{Dates.Date} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_date :: Bokeh.Model.Nullable{Dates.Date} = nothing

    default_size :: Int64 = 300

    enabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Dates.Date

    disabled_dates :: Vector{Union{Tuple{Dates.Date, Dates.Date}, Dates.Date}}

    inline :: Bool = false

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct CustomJS <: iCustomJS

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{String, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Filter <: iFilter

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ColorBar <: iColorBar

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    height :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    minor_tick_out :: Int64 = 0

    title_text_font :: String = "helvetica"

    bar_line_dash_offset :: Int64 = 0

    major_label_text_line_height :: Float64 = 1.2

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    bar_line_alpha :: Bokeh.Model.Percent = 1.0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    margin :: Int64 = 30

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    major_tick_out :: Int64 = 0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    title :: Bokeh.Model.Nullable{String} = nothing

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bar_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    color_mapper :: iColorMapper

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    major_tick_line_dash :: Bokeh.Model.DashPattern

    border_line_width :: Float64 = 1.0

    major_tick_line_dash_offset :: Int64 = 0

    title_text_line_height :: Float64 = 1.2

    bar_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    bar_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    bar_line_dash :: Bokeh.Model.DashPattern

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: Union{iTickFormatter, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    label_standoff :: Int64 = 5

    padding :: Int64 = 10

    ticker :: Union{iTicker, Bokeh.Model.EnumType{(:auto,)}} = :auto

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    border_line_dash :: Bokeh.Model.DashPattern

    width :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    major_tick_in :: Int64 = 5

    orientation :: Bokeh.Model.EnumType{(:horizontal, :vertical, :auto)} = :auto

    border_line_dash_offset :: Int64 = 0

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    bar_line_width :: Float64 = 1.0

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = NoOverlap()

    scale_alpha :: Float64 = 1.0

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    title_standoff :: Int64 = 2

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct Toolbar <: iToolbar

    syncable :: Bool = true

    active_scroll :: Union{Nothing, iScroll, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    tools :: Vector{iTool}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    active_drag :: Union{Nothing, iDrag, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    active_inspect :: Union{Nothing, iInspectTool, Bokeh.Model.EnumType{(:auto,)}, Vector{iInspectTool}} = Bokeh.Model.Unknown()

    active_multi :: Union{Nothing, iGestureTool, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    active_tap :: Union{Nothing, iTap, Bokeh.Model.EnumType{(:auto,)}} = Bokeh.Model.Unknown()
end

@model mutable struct EditTool <: iEditTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct WebDataSource <: iWebDataSource

    syncable :: Bool = true

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.DataDict

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()

    data_url :: String

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct HTMLBox <: iHTMLBox

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct LogColorMapper <: iLogColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PolyDrawTool <: iPolyDrawTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    drag :: Bool = true

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    vertex_renderer :: Bokeh.Model.Nullable{iGlyphRenderer} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct SumAggregator <: iSumAggregator

    syncable :: Bool = true

    field_ :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct OpenHead <: iOpenHead

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Patches <: iPatches

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    ys :: Bokeh.Model.Spec{Float64} = (field = "ys",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    xs :: Bokeh.Model.Spec{Float64} = (field = "xs",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CategoricalPatternMapper <: iCategoricalPatternMapper

    syncable :: Bool = true

    start :: Int64 = 0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    default_value :: Bokeh.Model.EnumType{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = :blank

    patterns :: Vector{Bokeh.Model.EnumType{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)}}

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LabelSet <: iLabelSet

    syncable :: Bool = true

    source :: iDataSource = ColumnDataSource()

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    text_font :: Bokeh.Model.Spec{String} = (value = "helvetica",)

    border_line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    visible :: Bool = true

    text_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    text_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    text :: Bokeh.Model.Spec{String} = (field = "text",)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    border_line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    background_fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    background_fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    x_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    text_line_height :: Bokeh.Model.Spec{Float64} = (value = 1.2,)

    y_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    text_baseline :: Bokeh.Model.EnumSpec{(:top, :middle, :bottom, :alphabetic, :hanging, :ideographic)} = (value = :bottom,)

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    text_font_style :: Bokeh.Model.EnumSpec{(:normal, :italic, :bold, Symbol("bold italic"))} = (value = :normal,)

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    border_line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    text_font_size :: Bokeh.Model.FontSizeSpec = (value = "16px",)

    name :: Bokeh.Model.Nullable{String} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    x_offset :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    border_line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    border_line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    border_line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    border_line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    text_align :: Bokeh.Model.EnumSpec{(:left, :right, :center)} = (value = :left,)
end

@model mutable struct Bezier <: iBezier

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    cx0 :: Bokeh.Model.Spec{Float64} = (field = "cx0",)

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    y0 :: Bokeh.Model.Spec{Float64} = (field = "y0",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    cy0 :: Bokeh.Model.Spec{Float64} = (field = "cy0",)

    cx1 :: Bokeh.Model.Spec{Float64} = (field = "cx1",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    x0 :: Bokeh.Model.Spec{Float64} = (field = "x0",)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    x1 :: Bokeh.Model.Spec{Float64} = (field = "x1",)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y1 :: Bokeh.Model.Spec{Float64} = (field = "y1",)

    cy1 :: Bokeh.Model.Spec{Float64} = (field = "cy1",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DateFormatter <: iDateFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    format :: Union{String, Bokeh.Model.EnumType{(:ATOM, :W3C, Symbol("RFC-3339"), Symbol("ISO-8601"), :COOKIE, Symbol("RFC-822"), Symbol("RFC-850"), Symbol("RFC-1036"), Symbol("RFC-1123"), Symbol("RFC-2822"), :RSS, :TIMESTAMP)}} = Symbol("ISO-8601")

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct PointDrawTool <: iPointDrawTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    add :: Bool = true

    drag :: Bool = true

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct BinnedTicker <: iBinnedTicker

    syncable :: Bool = true

    num_major_ticks :: Union{Int64, Bokeh.Model.EnumType{(:auto,)}} = 8

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    mapper :: iScanningColorMapper

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct GestureTool <: iGestureTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TextInput <: iTextInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    value_input :: String = ""

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    max_length :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: String = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct DomAction <: iDomAction

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct GraphCoordinates <: iGraphCoordinates

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    layout :: iLayoutProvider

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct HArea <: iHArea

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    fill_alpha :: Bokeh.Model.Percent = 1.0

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    x1 :: Bokeh.Model.Spec{Float64} = (field = "x1",)

    fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    x2 :: Bokeh.Model.Spec{Float64} = (field = "x2",)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Whisker <: iWhisker

    syncable :: Bool = true

    source :: iDataSource = ColumnDataSource()

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    upper :: Bokeh.Model.PropertyUnitsSpec = (field = "upper",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    lower_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    upper_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    lower :: Bokeh.Model.PropertyUnitsSpec = (field = "lower",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    base_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    x_range_name :: String = "default"

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :height

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    lower_head :: Bokeh.Model.Nullable{iArrowHead} = TeeHead()

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    base :: Bokeh.Model.PropertyUnitsSpec = (field = "base",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    upper_head :: Bokeh.Model.Nullable{iArrowHead} = TeeHead()
end

@model mutable struct LassoSelectTool <: iLassoSelectTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    overlay :: iPolyAnnotation = PolyAnnotation()

    subscribed_events :: Vector{String} = String[]

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    select_every_mousemove :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Button <: iButton

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    label :: String = "Button"

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.Nullable{iAbstractIcon} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct NodesOnly <: iNodesOnly

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TextEditor <: iTextEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TapTool <: iTapTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    behavior :: Bokeh.Model.EnumType{(:select, :inspect)} = :select

    subscribed_events :: Vector{String} = String[]

    gesture :: Bokeh.Model.EnumType{(:tap, :doubletap)} = :tap

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    names :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Marker <: iMarker

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.SizeSpec = (value = 4.0,)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    hit_dilation :: Bokeh.Model.Size = 1.0

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct StaticLayoutProvider <: iStaticLayoutProvider

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    graph_layout :: Dict{Union{Int64, String}, Vector{Any}}
end

@model mutable struct ToolbarBase <: iToolbarBase

    syncable :: Bool = true

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    tools :: Vector{iTool}

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DataRange1d <: iDataRange1d

    syncable :: Bool = true

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iModel}}

    start :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    follow_interval :: Bokeh.Model.Nullable{Union{Float64, Dates.Period}} = nothing

    range_padding :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    subscribed_events :: Vector{String} = String[]

    finish :: Union{Nothing, Float64, Dates.DateTime, Dates.Period} = nothing

    only_visible :: Bool = false

    default_span :: Union{Float64, Dates.Period} = Bokeh.Model.Unknown()

    follow :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:start, :end)}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    min_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    max_interval :: Union{Nothing, Float64, Dates.Period} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    flipped :: Bool = false

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ScalarExpression <: iScalarExpression

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Annotation <: iAnnotation

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DomIndex <: iDomIndex

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct BooleanFilter <: iBooleanFilter

    syncable :: Bool = true

    booleans :: Bokeh.Model.Nullable{Vector{Bool}} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DatetimeTicker <: iDatetimeTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    subscribed_events :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tickers :: Vector{iTicker}

    tags :: Vector{Any}
end

@model mutable struct Stack <: iStack

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    fields :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Dodge <: iDodge

    syncable :: Bool = true

    value :: Float64 = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    range :: Bokeh.Model.Nullable{iRange} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Quadratic <: iQuadratic

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    cx :: Bokeh.Model.Spec{Float64} = (field = "cx",)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    y0 :: Bokeh.Model.Spec{Float64} = (field = "y0",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    x0 :: Bokeh.Model.Spec{Float64} = (field = "x0",)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    cy :: Bokeh.Model.Spec{Float64} = (field = "cy",)

    x1 :: Bokeh.Model.Spec{Float64} = (field = "x1",)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y1 :: Bokeh.Model.Spec{Float64} = (field = "y1",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ColorPicker <: iColorPicker

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    color :: Bokeh.Model.ColorHex = Bokeh.Model.Unknown()

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct TextLikeInput <: iTextLikeInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    value_input :: String = ""

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    max_length :: Bokeh.Model.Nullable{Int64} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: String = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Legend <: iLegend

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    label_height :: Int64 = 20

    label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    label_width :: Int64 = 20

    label_text_alpha :: Bokeh.Model.Percent = 1.0

    title_text_font :: String = "helvetica"

    title_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    name :: Bokeh.Model.Nullable{String} = nothing

    inactive_fill_alpha :: Bokeh.Model.Percent = 1.0

    y_range_name :: String = "default"

    title_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    border_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    margin :: Int64 = 10

    border_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    border_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    title_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    label_text_font_size :: Bokeh.Model.FontSize = "16px"

    label_text_line_height :: Float64 = 1.2

    label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    glyph_width :: Int64 = 20

    title :: Bokeh.Model.Nullable{String} = nothing

    background_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    title_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    border_line_width :: Float64 = 1.0

    click_policy :: Bokeh.Model.EnumType{(:none, :hide, :mute)} = :none

    title_text_line_height :: Float64 = 1.2

    tags :: Vector{Any}

    background_fill_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    border_line_alpha :: Bokeh.Model.Percent = 1.0

    label_standoff :: Int64 = 5

    padding :: Int64 = 10

    label_text_font :: String = "helvetica"

    title_text_font_size :: Bokeh.Model.FontSize = "16px"

    border_line_dash :: Bokeh.Model.DashPattern

    location :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:top_left, :top_center, :top_right, :center_left, :center_center, :center_right, :bottom_left, :bottom_center, :bottom_right, :top, :left, :center, :right, :bottom)}} = :top_right

    spacing :: Int64 = 3

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :vertical

    border_line_dash_offset :: Int64 = 0

    label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    title_text_alpha :: Bokeh.Model.Percent = 1.0

    x_range_name :: String = "default"

    items :: Vector{iLegendItem}

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    inactive_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    glyph_height :: Int64 = 20

    title_standoff :: Int64 = 5
end

@model mutable struct GroupingInfo <: iGroupingInfo

    syncable :: Bool = true

    aggregators :: Vector{iRowAggregator}

    collapsed :: Bool = false

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    getter :: String = ""

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CustomAction <: iCustomAction

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    icon :: Bokeh.Model.Image

    subscribed_events :: Vector{String} = String[]

    callback :: Bokeh.Model.Nullable{iCallback} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DataAnnotation <: iDataAnnotation

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()
end

@model mutable struct Markup <: iMarkup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    text :: String = ""

    disable_math :: Bool = false

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    style :: Dict{String, Any}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct BoxEditTool <: iBoxEditTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LayoutProvider <: iLayoutProvider

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct PolyTool <: iPolyTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    vertex_renderer :: Bokeh.Model.Nullable{iGlyphRenderer} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DataRenderer <: iDataRenderer

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CustomJSHover <: iCustomJSHover

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{String, iModel}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DomDOMNode <: iDomDOMNode

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct IntersectRenderers <: iIntersectRenderers

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct WheelPanTool <: iWheelPanTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    dimension :: Bokeh.Model.EnumType{(:height, :width)} = :width

    tags :: Vector{Any}
end

@model mutable struct StringFormatter <: iStringFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct SelectEditor <: iSelectEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    options :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct ButtonGroup <: iButtonGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    button_type :: Bokeh.Model.EnumType{(:warning, :default, :success, :light, :danger, :primary)} = :default

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct AdaptiveTicker <: iAdaptiveTicker

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    desired_num_ticks :: Int64 = 6

    base :: Float64 = 10.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct FactorRange <: iFactorRange

    syncable :: Bool = true

    group_padding :: Float64 = 1.4

    subgroup_padding :: Float64 = 0.8

    range_padding_units :: Bokeh.Model.EnumType{(:percent, :absolute)} = :percent

    start :: Bokeh.Model.ReadOnly{Float64} = 0.0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    range_padding :: Float64 = 0.0

    subscribed_events :: Vector{String} = String[]

    finish :: Bokeh.Model.ReadOnly{Float64} = 0.0

    name :: Bokeh.Model.Nullable{String} = nothing

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Bokeh.Model.Nullable{Float64} = nothing

    bounds :: Bokeh.Model.Nullable{Bokeh.Model.MinMaxBounds} = nothing

    factor_padding :: Float64 = 0.0

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ContinuousScale <: iContinuousScale

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TeeHead <: iTeeHead

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.Spec{Float64} = (value = 25.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ContinuousAxis <: iContinuousAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct HTMLTemplateFormatter <: iHTMLTemplateFormatter

    syncable :: Bool = true

    template :: String = "<%= value %>"

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct EqHistColorMapper <: iEqHistColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    rescale_discrete_levels :: Bool = false

    subscribed_events :: Vector{String} = String[]

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    bins :: Int64 = 65536

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ColumnarDataSource <: iColumnarDataSource

    syncable :: Bool = true

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    name :: Bokeh.Model.Nullable{String} = nothing

    selection_policy :: iSelectionPolicy = UnionRenderers()

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct LogAxis <: iLogAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct GroupFilter <: iGroupFilter

    syncable :: Bool = true

    group :: String

    column_name :: String

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct AjaxDataSource <: iAjaxDataSource

    syncable :: Bool = true

    if_modified :: Bool = false

    max_size :: Bokeh.Model.Nullable{Int64} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    method :: Bokeh.Model.EnumType{(:POST, :GET)} = :POST

    content_type :: String = "application/json"

    polling_interval :: Bokeh.Model.Nullable{Int64} = nothing

    http_headers :: Dict{String, String}

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.DataDict

    mode :: Bokeh.Model.EnumType{(:append, :replace)} = :replace

    adapter :: Bokeh.Model.Nullable{iCustomJS} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    selected :: Bokeh.Model.ReadOnly{iSelection} = Selection()

    data_url :: String

    selection_policy :: iSelectionPolicy = UnionRenderers()

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Texture <: iTexture

    syncable :: Bool = true

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Box <: iBox

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    spacing :: Int64 = 0

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    children :: Vector{iLayoutDOM}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct WheelZoomTool <: iWheelZoomTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    maintain_focus :: Bool = true

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    speed :: Float64 = 0.0016666666666666668

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    zoom_on_axis :: Bool = true
end

@model mutable struct DateRangeSlider <: iDateRangeSlider

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Tuple{Dates.DateTime, Dates.DateTime}}

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Dates.DateTime

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tooltips :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    finish :: Dates.DateTime

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Tuple{Dates.DateTime, Dates.DateTime}

    step :: Int64 = 1

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct MercatorTicker <: iMercatorTicker

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    mantissas :: Vector{Float64} = [1.0, 2.0, 5.0]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    max_interval :: Bokeh.Model.Nullable{Float64} = nothing

    min_interval :: Float64 = 0.0

    dimension :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:lat, :lon)}} = nothing

    desired_num_ticks :: Int64 = 6

    base :: Float64 = 10.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct HBar <: iHBar

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    height :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    left :: Bokeh.Model.Spec{Float64} = (value = 0.0,)

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    right :: Bokeh.Model.Spec{Float64} = (field = "right",)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}
end

@model mutable struct DateEditor <: iDateEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MultiLine <: iMultiLine

    syncable :: Bool = true

    ys :: Bokeh.Model.Spec{Float64} = (field = "ys",)

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    xs :: Bokeh.Model.Spec{Float64} = (field = "xs",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CategoricalMapper <: iCategoricalMapper

    syncable :: Bool = true

    factors :: Union{Vector{String}, Vector{Tuple{String, String}}, Vector{Tuple{String, String, String}}}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    start :: Int64 = 0

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    finish :: Bokeh.Model.Nullable{Int64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Scatter <: iScatter

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    size :: Bokeh.Model.SizeSpec = (value = 4.0,)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    hit_dilation :: Bokeh.Model.Size = 1.0

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    marker :: Bokeh.Model.EnumSpec{(:asterisk, :circle, :circle_cross, :circle_dot, :circle_x, :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot, :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square, :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot, :triangle, :triangle_dot, :triangle_pin, :x, :y)} = (value = :circle,)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CustomJSFilter <: iCustomJSFilter

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{Bokeh.Model.RestrictedKey{(:source,)}, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ResetTool <: iResetTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct RadioGroup <: iRadioGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Bokeh.Model.Nullable{Int64} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    inline :: Bool = false

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct RangeSlider <: iRangeSlider

    syncable :: Bool = true

    value_throttled :: Bokeh.Model.ReadOnly{Tuple{Float64, Float64}}

    css_classes :: Vector{String} = String[]

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    show_value :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    start :: Float64

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    orientation :: Bokeh.Model.EnumType{(:vertical, :horizontal)} = :horizontal

    tags :: Vector{Any}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tooltips :: Bool = true

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: Bokeh.Model.Nullable{String} = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    finish :: Float64

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{iTickFormatter, String} = ""

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Tuple{Float64, Float64}

    step :: Float64 = 1.0

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    bar_color :: Bokeh.Model.Color = "rgb(230,230,230)"

    direction :: Bokeh.Model.EnumType{(:rtl, :ltr)} = :ltr

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Tabs <: iTabs

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Int64 = 0

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tabs_location :: Bokeh.Model.EnumType{(:below, :left, :right, :above)} = :above

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    tabs :: Vector{iPanel}

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct GlyphRenderer <: iGlyphRenderer

    syncable :: Bool = true

    selection_glyph :: Bokeh.Model.Nullable{Union{iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    nonselection_glyph :: Bokeh.Model.Nullable{Union{iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    muted :: Bool = false

    subscribed_events :: Vector{String} = String[]

    glyph :: iGlyph

    name :: Bokeh.Model.Nullable{String} = nothing

    hover_glyph :: Bokeh.Model.Nullable{iGlyph} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    muted_glyph :: Bokeh.Model.Nullable{Union{iGlyph, Bokeh.Model.EnumType{(:auto,)}}} = :auto

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    view :: iCDSView

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    data_source :: iDataSource

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct BBoxTileSource <: iBBoxTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    snap_to_zoom :: Bool = false

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    wrap_around :: Bool = true

    use_latlon :: Bool = false

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct XYGlyph <: iXYGlyph

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct EdgesAndLinkedNodes <: iEdgesAndLinkedNodes

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct NumericInput <: iNumericInput

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    title :: String = ""

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    mode :: Bokeh.Model.EnumType{(:int, :float)} = :int

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    placeholder :: String = ""

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    format :: Union{Nothing, iTickFormatter, String} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Union{Nothing, Float64, Int64} = nothing

    high :: Union{Nothing, Float64, Int64} = nothing

    low :: Union{Nothing, Float64, Int64} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct PercentEditor <: iPercentEditor

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Slope <: iSlope

    syncable :: Bool = true

    gradient :: Bokeh.Model.Nullable{Float64} = nothing

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    y_intercept :: Bokeh.Model.Nullable{Float64} = nothing

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    line_width :: Float64 = 1.0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    line_dash_offset :: Int64 = 0

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Rect <: iRect

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    height :: Bokeh.Model.DistanceSpec = (field = "height",)

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    height_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    dilate :: Bool = false

    angle :: Bokeh.Model.UnitSpec{Float64, (:rad, :deg, :grad, :turn)} = (value = 0.0,)

    name :: Bokeh.Model.Nullable{String} = nothing

    width_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    angle_units :: Bokeh.Model.EnumType{(:rad, :turn, :deg, :grad)} = :rad

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.DistanceSpec = (field = "width",)
end

@model mutable struct Annulus <: iAnnulus

    syncable :: Bool = true

    hatch_extra :: Dict{String, iTexture}

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    hatch_scale :: Bokeh.Model.Spec{Float64} = (value = 12.0,)

    inner_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    hatch_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    fill_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    hatch_pattern :: Bokeh.Model.EnumSpec{(:blank, :dot, :ring, :horizontal_line, :vertical_line, :cross, :horizontal_dash, :vertical_dash, :spiral, :right_diagonal_line, :left_diagonal_line, :diagonal_cross, :right_diagonal_dash, :left_diagonal_dash, :horizontal_wave, :vertical_wave, :criss_cross)} = nothing

    subscribed_events :: Vector{String} = String[]

    hatch_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    name :: Bokeh.Model.Nullable{String} = nothing

    outer_radius :: Bokeh.Model.DistanceSpec = (field = "outer_radius",)

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    outer_radius_units :: Bokeh.Model.EnumType{(:screen, :data)} = :data

    fill_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    inner_radius :: Bokeh.Model.DistanceSpec = (field = "inner_radius",)

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    hatch_weight :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct FuncTickFormatter <: iFuncTickFormatter

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{String, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ProxyToolbar <: iProxyToolbar

    syncable :: Bool = true

    tools :: Vector{iTool}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    logo :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:normal, :grey)}} = :normal

    subscribed_events :: Vector{String} = String[]

    toolbars :: Vector{iToolbar}

    name :: Bokeh.Model.Nullable{String} = nothing

    autohide :: Bool = false

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct ImageURLTexture <: iImageURLTexture

    syncable :: Bool = true

    url :: String

    repetition :: Bokeh.Model.EnumType{(:repeat_y, :repeat_x, :no_repeat, :repeat)} = :repeat

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct OpenURL <: iOpenURL

    syncable :: Bool = true

    url :: String = "http://"

    name :: Bokeh.Model.Nullable{String} = nothing

    same_tab :: Bool = false

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Ticker <: iTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CategoricalTicker <: iCategoricalTicker

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct IntEditor <: iIntEditor

    syncable :: Bool = true

    step :: Int64 = 1

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Select <: iSelect

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    options :: Union{Dict{String, Vector{Union{String, Tuple{String, String}}}}, Vector{Union{String, Tuple{String, String}}}}

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    title :: String = ""

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: String = ""

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct WMTSTileSource <: iWMTSTileSource

    syncable :: Bool = true

    min_zoom :: Int64 = 0

    extra_url_vars :: Dict{String, Any}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    snap_to_zoom :: Bool = false

    initial_resolution :: Bokeh.Model.Nullable{Float64} = nothing

    attribution :: String = ""

    y_origin_offset :: Float64

    tile_size :: Int64 = 256

    subscribed_events :: Vector{String} = String[]

    max_zoom :: Int64 = 30

    url :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    x_origin_offset :: Float64

    wrap_around :: Bool = true

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct AvgAggregator <: iAvgAggregator

    syncable :: Bool = true

    field_ :: String = ""

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Line <: iLine

    syncable :: Bool = true

    line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    x :: Bokeh.Model.Spec{Float64} = (field = "x",)

    line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Float64 = 1.0

    line_dash_offset :: Int64 = 0

    y :: Bokeh.Model.Spec{Float64} = (field = "y",)

    line_dash :: Bokeh.Model.DashPattern

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct MultiSelect <: iMultiSelect

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    size :: Int64 = 4

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    options :: Vector{Union{String, Tuple{String, String}}}

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    title :: String = ""

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    value :: Vector{String} = String[]

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct LogTickFormatter <: iLogTickFormatter

    syncable :: Bool = true

    min_exponent :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    ticker :: Bokeh.Model.Nullable{iTicker} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Widget <: iWidget

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct GridBox <: iGridBox

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    spacing :: Union{Int64, Tuple{Int64, Int64}} = 0

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    cols :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :width, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    rows :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :height, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    children :: Vector{Union{Tuple{iLayoutDOM, Int64, Int64}, Tuple{iLayoutDOM, Int64, Int64, Int64, Int64}}}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct ZoomInTool <: iZoomInTool

    syncable :: Bool = true

    factor :: Bokeh.Model.Percent = 0.1

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct BoxSelectTool <: iBoxSelectTool

    syncable :: Bool = true

    origin :: Bokeh.Model.EnumType{(:corner, :center)} = :corner

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    overlay :: iBoxAnnotation = BoxAnnotation()

    subscribed_events :: Vector{String} = String[]

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    select_every_mousemove :: Bool = false

    dimensions :: Bokeh.Model.EnumType{(:both, :height, :width)} = :both

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Row <: iRow

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    spacing :: Int64 = 0

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    cols :: Union{Int64, Dict{Union{Int64, String}, Union{Int64, NamedTuple{(:policy, :align), Tuple{Bokeh.Model.EnumType{(:auto, :min)}, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :flex, :align), Tuple{Bokeh.Model.EnumType{(:max, :fit)}, Float64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, NamedTuple{(:policy, :width, :align), Tuple{Bokeh.Model.EnumType{(:fixed,)}, Int64, Bokeh.Model.EnumType{(:auto, :start, :center, :end)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}}}, Bokeh.Model.EnumType{(:auto, :min, :fit, :max)}} = Bokeh.Model.Unknown()

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    children :: Vector{iLayoutDOM}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct PolySelectTool <: iPolySelectTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Union{Bokeh.Model.EnumType{(:auto,)}, Vector{iDataRenderer}} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    overlay :: iPolyAnnotation = PolyAnnotation()

    subscribed_events :: Vector{String} = String[]

    mode :: Bokeh.Model.EnumType{(:append, :replace, :subtract, :intersect)} = :replace

    name :: Bokeh.Model.Nullable{String} = nothing

    names :: Vector{String} = String[]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Grid <: iGrid

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_grid_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    grid_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    visible :: Bool = true

    axis :: Bokeh.Model.Nullable{iAxis} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    band_hatch_alpha :: Bokeh.Model.Percent = 1.0

    band_hatch_extra :: Dict{String, iTexture}

    band_hatch_pattern :: Bokeh.Model.Nullable{String} = nothing

    grid_line_dash :: Bokeh.Model.DashPattern

    grid_line_alpha :: Bokeh.Model.Percent = 1.0

    band_hatch_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    subscribed_events :: Vector{String} = String[]

    band_fill_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(128,128,128)"

    grid_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    band_hatch_weight :: Bokeh.Model.Size = 1.0

    minor_grid_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    grid_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    grid_line_dash_offset :: Int64 = 0

    name :: Bokeh.Model.Nullable{String} = nothing

    band_hatch_scale :: Bokeh.Model.Size = 12.0

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    minor_grid_line_width :: Float64 = 1.0

    minor_grid_line_dash :: Bokeh.Model.DashPattern

    bounds :: Union{Tuple{Float64, Float64}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    dimension :: Int64 = 0

    band_fill_alpha :: Bokeh.Model.Percent = 1.0

    minor_grid_line_dash_offset :: Int64 = 0

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    grid_line_width :: Float64 = 1.0

    minor_grid_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    ticker :: Bokeh.Model.Nullable{iTicker} = nothing

    minor_grid_line_alpha :: Bokeh.Model.Percent = 1.0

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct NumeralTickFormatter <: iNumeralTickFormatter

    syncable :: Bool = true

    rounding :: Bokeh.Model.EnumType{(:rounddown, :round, :nearest, :floor, :ceil, :roundup)} = :round

    language :: Bokeh.Model.EnumType{(Symbol("da-dk"), :de, :en, :th, :chs, Symbol("fr-ch"), :pl, :tr, Symbol("pt-pt"), Symbol("es-ES"), :fr, Symbol("pt-br"), :es, Symbol("en-gb"), :ja, :hu, Symbol("fr-CA"), Symbol("de-ch"), Symbol("nl-nl"), :it, :ru, Symbol("ru-UA"), :fi, Symbol("be-nl"), :cs, :et, :sk, Symbol("uk-UA"))} = :en

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    format :: String = "0,0"

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct EdgesOnly <: iEdgesOnly

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct FreehandDrawTool <: iFreehandDrawTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_objects :: Int64 = 0

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CoordinateTransform <: iCoordinateTransform

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct CategoricalScale <: iCategoricalScale

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct MercatorAxis <: iMercatorAxis

    syncable :: Bool = true

    axis_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    axis_label_text_font :: String = "helvetica"

    axis_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_standoff :: Int64 = 5

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    minor_tick_out :: Int64 = 4

    major_label_text_line_height :: Float64 = 1.2

    axis_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    minor_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    axis_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    axis_label_text_line_height :: Float64 = 1.2

    minor_tick_line_dash :: Bokeh.Model.DashPattern

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    visible :: Bool = true

    major_tick_out :: Int64 = 6

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    major_label_text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    major_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    axis_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    minor_tick_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    minor_tick_line_dash_offset :: Int64 = 0

    minor_tick_in :: Int64 = 0

    major_label_text_font :: String = "helvetica"

    major_label_overrides :: Dict{Union{Float64, String}, Union{iBaseText, String}}

    bounds :: Union{Tuple{Float64, Float64}, Tuple{Dates.DateTime, Dates.DateTime}, Bokeh.Model.EnumType{(:auto,)}} = :auto

    major_tick_line_dash :: Bokeh.Model.DashPattern

    major_tick_line_dash_offset :: Int64 = 0

    axis_label_text_font_size :: Bokeh.Model.FontSize = "16px"

    minor_tick_line_width :: Float64 = 1.0

    tags :: Vector{Any}

    major_tick_line_width :: Float64 = 1.0

    axis_line_alpha :: Bokeh.Model.Percent = 1.0

    minor_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    subscribed_events :: Vector{String} = String[]

    major_label_text_baseline :: Bokeh.Model.EnumType{(:middle, :bottom, :top, :hanging, :alphabetic, :ideographic)} = :bottom

    formatter :: iTickFormatter

    major_label_text_alpha :: Bokeh.Model.Percent = 1.0

    axis_line_join :: Bokeh.Model.EnumType{(:round, :miter, :bevel)} = :bevel

    major_label_standoff :: Int64 = 5

    ticker :: iTicker

    major_tick_line_alpha :: Bokeh.Model.Percent = 1.0

    axis_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    axis_line_width :: Float64 = 1.0

    major_tick_in :: Int64 = 2

    axis_label :: Bokeh.Model.Nullable{Union{iBaseText, String}} = nothing

    minor_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(68,68,68)"

    major_tick_line_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = "rgb(0,0,0)"

    major_label_text_font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    major_label_policy :: iLabelingPolicy = AllLabels()

    fixed_location :: Union{Nothing, Float64, String, Tuple{String, String}, Tuple{String, String, String}} = nothing

    x_range_name :: String = "default"

    major_label_orientation :: Union{Float64, Bokeh.Model.EnumType{(:horizontal, :vertical)}} = :horizontal

    major_tick_line_cap :: Bokeh.Model.EnumType{(:round, :square, :butt)} = :butt

    axis_line_dash_offset :: Int64 = 0

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    axis_line_dash :: Bokeh.Model.DashPattern

    major_label_text_font_size :: Bokeh.Model.FontSize = "16px"
end

@model mutable struct CheckboxGroup <: iCheckboxGroup

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    active :: Vector{Int64} = Int64[]

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    labels :: Vector{String} = String[]

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    inline :: Bool = false

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct Drag <: iDrag

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct Segment <: iSegment

    syncable :: Bool = true

    line_color :: Bokeh.Model.Spec{Bokeh.Model.Color} = Bokeh.Model.Unknown()

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    line_alpha :: Bokeh.Model.AlphaSpec = (value = 1.0,)

    y0 :: Bokeh.Model.Spec{Float64} = (field = "y0",)

    subscribed_events :: Vector{String} = String[]

    line_cap :: Bokeh.Model.EnumSpec{(:butt, :round, :square)} = (value = :butt,)

    line_join :: Bokeh.Model.EnumSpec{(:miter, :round, :bevel)} = (value = :bevel,)

    x0 :: Bokeh.Model.Spec{Float64} = (field = "x0",)

    name :: Bokeh.Model.Nullable{String} = nothing

    line_width :: Bokeh.Model.Spec{Float64} = (value = 1.0,)

    x1 :: Bokeh.Model.Spec{Float64} = (field = "x1",)

    line_dash_offset :: Bokeh.Model.Spec{Int64} = (value = 0,)

    y1 :: Bokeh.Model.Spec{Float64} = (field = "y1",)

    line_dash :: Bokeh.Model.Spec{Bokeh.Model.DashPattern}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct TextAnnotation <: iTextAnnotation

    syncable :: Bool = true

    group :: Bokeh.Model.Nullable{iRendererGroup} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    y_range_name :: String = "default"

    x_range_name :: String = "default"

    render_mode :: Bokeh.Model.EnumType{(:canvas, :css)} = :canvas

    coordinates :: Bokeh.Model.Nullable{iCoordinateMapping} = nothing

    level :: Bokeh.Model.EnumType{(:annotation, :underlay, :image, :overlay, :guide, :glyph)} = :image

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct DatetimeTickFormatter <: iDatetimeTickFormatter

    syncable :: Bool = true

    months :: Vector{String} = ["%m/%Y", "%b %Y"]

    minutes :: Vector{String} = [":%M", "%Mm"]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    minsec :: Vector{String} = [":%M:%S"]

    tags :: Vector{Any}

    years :: Vector{String} = ["%Y"]

    hours :: Vector{String} = ["%Hh", "%H:%M"]

    subscribed_events :: Vector{String} = String[]

    hourmin :: Vector{String} = ["%H:%M"]

    microseconds :: Vector{String} = ["%fus"]

    name :: Bokeh.Model.Nullable{String} = nothing

    milliseconds :: Vector{String} = ["%3Nms", "%S.%3Ns"]

    days :: Vector{String} = ["%m/%d", "%a%d"]

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    seconds :: Vector{String} = ["%Ss"]
end

@model mutable struct PolyEditTool <: iPolyEditTool

    syncable :: Bool = true

    description :: Bokeh.Model.Nullable{String} = nothing

    renderers :: Vector{iGlyphRenderer}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    custom_icon :: Bokeh.Model.Nullable{Bokeh.Model.Image} = nothing

    empty_value :: Union{Bool, Float64, Int64, Dates.Date, Dates.DateTime, Bokeh.Model.Color, String}

    vertex_renderer :: Bokeh.Model.Nullable{iGlyphRenderer} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct StepInterpolator <: iStepInterpolator

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    clip :: Bool = true

    subscribed_events :: Vector{String} = String[]

    data :: Bokeh.Model.Nullable{iColumnarDataSource} = nothing

    x :: Union{String, Vector{Float64}}

    mode :: Bokeh.Model.EnumType{(:after, :before, :center)} = :after

    name :: Bokeh.Model.Nullable{String} = nothing

    y :: Union{String, Vector{Float64}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Range <: iRange

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TableWidget <: iTableWidget

    syncable :: Bool = true

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    tags :: Vector{Any}

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    view :: iCDSView

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    source :: iDataSource = ColumnDataSource()

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct DomText <: iDomText

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    content :: String = ""

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct DataCube <: iDataCube

    syncable :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    fit_columns :: Bokeh.Model.Nullable{Bool} = nothing

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    target :: iDataSource

    view :: iCDSView

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    visible :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    columns :: Vector{iTableColumn}

    index_header :: String = "#"

    sortable :: Bool = true

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    source :: iDataSource = ColumnDataSource()

    frozen_rows :: Bokeh.Model.Nullable{Int64} = nothing

    index_position :: Bokeh.Model.Nullable{Int64} = 0

    css_classes :: Vector{String} = String[]

    header_row :: Bool = true

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    row_height :: Int64 = 25

    auto_edit :: Bool = false

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    subscribed_events :: Vector{String} = String[]

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    selectable :: Union{Bool, Bokeh.Model.EnumType{(:checkbox,)}} = true

    editable :: Bool = false

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    frozen_columns :: Bokeh.Model.Nullable{Int64} = nothing

    grouping :: Vector{iGroupingInfo}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    scroll_to_selection :: Bool = true

    disabled :: Bool = false

    index_width :: Int64 = 40

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    autosize_mode :: Bokeh.Model.EnumType{(:none, :fit_columns, :fit_viewport, :force_fit)} = :force_fit

    reorderable :: Bool = true
end

@model mutable struct MonthsTicker <: iMonthsTicker

    months :: Vector{Int64} = Int64[]

    syncable :: Bool = true

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    interval :: Float64

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    name :: Bokeh.Model.Nullable{String} = nothing

    num_minor_ticks :: Int64 = 5

    desired_num_ticks :: Int64 = 6

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct CustomLabelingPolicy <: iCustomLabelingPolicy

    syncable :: Bool = true

    code :: String = ""

    args :: Dict{String, Any}

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct Div <: iDiv

    syncable :: Bool = true

    render_as_text :: Bool = false

    min_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    css_classes :: Vector{String} = String[]

    visible :: Bool = true

    height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    height_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    text :: String = ""

    disable_math :: Bool = false

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    disabled :: Bool = false

    width_policy :: Bokeh.Model.EnumType{(:auto, :fixed, :fit, :min, :max)} = :auto

    tags :: Vector{Any}

    min_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    sizing_mode :: Bokeh.Model.Nullable{Bokeh.Model.EnumType{(:stretch_width, :scale_both, :scale_width, :stretch_height, :stretch_both, :fixed, :scale_height)}} = nothing

    subscribed_events :: Vector{String} = String[]

    align :: Union{Tuple{Bokeh.Model.EnumType{(:start, :end, :center)}, Bokeh.Model.EnumType{(:start, :end, :center)}}, Bokeh.Model.EnumType{(:start, :center, :end)}} = :start

    max_width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    max_height :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing

    default_size :: Int64 = 300

    name :: Bokeh.Model.Nullable{String} = nothing

    background :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    aspect_ratio :: Union{Nothing, Float64, Bokeh.Model.EnumType{(:auto,)}} = nothing

    style :: Dict{String, Any}

    margin :: Bokeh.Model.Nullable{NTuple{4, Int64}} = (0, 0, 0, 0)

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    width :: Bokeh.Model.Nullable{Bokeh.Model.NonNegativeInt} = nothing
end

@model mutable struct ScanningColorMapper <: iScanningColorMapper

    syncable :: Bool = true

    low_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    domain :: Vector{Tuple{iGlyphRenderer, Union{String, Vector{String}}}}

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{String} = String[]

    nan_color :: Bokeh.Model.Color = "rgb(128,128,128)"

    high_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    name :: Bokeh.Model.Nullable{String} = nothing

    high :: Bokeh.Model.Nullable{Float64} = nothing

    palette :: Vector{Bokeh.Model.Color}

    low :: Bokeh.Model.Nullable{Float64} = nothing

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}
end

@model mutable struct LogScale <: iLogScale

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end

@model mutable struct TeX <: iTeX

    syncable :: Bool = true

    name :: Bokeh.Model.Nullable{String} = nothing

    inline :: Bool = false

    subscribed_events :: Vector{String} = String[]

    js_property_callbacks :: Dict{String, Vector{iCustomJS}}

    macros :: Dict{String, Union{String, Tuple{String, Int64}}}

    text :: String

    js_event_callbacks :: Dict{String, Vector{iCustomJS}}

    tags :: Vector{Any}
end
end
