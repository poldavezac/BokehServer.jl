#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#
#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#
module Models
using Dates
using ..Bokeh
using ..Model
using ..AbstractTypes
using ..ModelTypes: iAbstractButton, iWidget, iLayoutDOM, iModel
using ..ModelTypes: iAbstractGroup
using ..ModelTypes: iAbstractIcon
using ..ModelTypes: iAbstractSlider
using ..ModelTypes: iActionTool, iTool
using ..ModelTypes: iAdaptiveTicker, iContinuousTicker, iTicker
using ..ModelTypes: iAjaxDataSource, iWebDataSource, iColumnDataSource, iColumnarDataSource, iDataSource
using ..ModelTypes: iAllLabels, iLabelingPolicy
using ..ModelTypes: iAnnotation, iRenderer
using ..ModelTypes: iAnnularWedge, iGlyph
using ..ModelTypes: iAnnulus
using ..ModelTypes: iArc
using ..ModelTypes: iArrow, iDataAnnotation
using ..ModelTypes: iArrowHead
using ..ModelTypes: iAscii, iMathText, iBaseText
using ..ModelTypes: iAutocompleteInput, iTextInput, iTextLikeInput, iInputWidget
using ..ModelTypes: iAvgAggregator, iRowAggregator
using ..ModelTypes: iAxis, iGuideRenderer
using ..ModelTypes: iBBoxTileSource, iMercatorTileSource, iTileSource
using ..ModelTypes: iBand
using ..ModelTypes: iBasicTickFormatter, iTickFormatter
using ..ModelTypes: iBasicTicker
using ..ModelTypes: iBezier, iLineGlyph
using ..ModelTypes: iBinnedTicker
using ..ModelTypes: iBooleanFilter, iFilter
using ..ModelTypes: iBooleanFormatter, iCellFormatter
using ..ModelTypes: iBox
using ..ModelTypes: iBoxAnnotation
using ..ModelTypes: iBoxEditTool, iGestureTool
using ..ModelTypes: iBoxSelectTool
using ..ModelTypes: iBoxZoomTool, iDrag
using ..ModelTypes: iButton
using ..ModelTypes: iButtonGroup
using ..ModelTypes: iCDSView
using ..ModelTypes: iCallback
using ..ModelTypes: iCanvasTexture, iTexture
using ..ModelTypes: iCategoricalAxis
using ..ModelTypes: iCategoricalColorMapper, iMapper, iTransform
using ..ModelTypes: iCategoricalMapper
using ..ModelTypes: iCategoricalMarkerMapper
using ..ModelTypes: iCategoricalPatternMapper
using ..ModelTypes: iCategoricalScale, iScale
using ..ModelTypes: iCategoricalTickFormatter
using ..ModelTypes: iCategoricalTicker
using ..ModelTypes: iCellEditor
using ..ModelTypes: iCheckboxButtonGroup
using ..ModelTypes: iCheckboxEditor
using ..ModelTypes: iCheckboxGroup, iGroup
using ..ModelTypes: iCircle, iMarker
using ..ModelTypes: iColorBar
using ..ModelTypes: iColorMapper
using ..ModelTypes: iColorPicker
using ..ModelTypes: iColumn
using ..ModelTypes: iCompositeTicker
using ..ModelTypes: iConnectedXYGlyph, iXYGlyph
using ..ModelTypes: iContinuousAxis
using ..ModelTypes: iContinuousColorMapper
using ..ModelTypes: iContinuousScale
using ..ModelTypes: iCoordinateMapping
using ..ModelTypes: iCoordinateTransform, iExpression
using ..ModelTypes: iCrosshairTool, iInspectTool
using ..ModelTypes: iCumSum
using ..ModelTypes: iCustomAction
using ..ModelTypes: iCustomJS
using ..ModelTypes: iCustomJSExpr
using ..ModelTypes: iCustomJSFilter
using ..ModelTypes: iCustomJSHover
using ..ModelTypes: iCustomJSTransform
using ..ModelTypes: iCustomLabelingPolicy
using ..ModelTypes: iDataCube, iDataTable, iTableWidget
using ..ModelTypes: iDataModel
using ..ModelTypes: iDataRange, iRange
using ..ModelTypes: iDataRange1d
using ..ModelTypes: iDataRenderer
using ..ModelTypes: iDateEditor
using ..ModelTypes: iDateFormatter, iStringFormatter
using ..ModelTypes: iDatePicker
using ..ModelTypes: iDateRangeSlider
using ..ModelTypes: iDateSlider
using ..ModelTypes: iDatetimeAxis, iLinearAxis
using ..ModelTypes: iDatetimeRangeSlider
using ..ModelTypes: iDatetimeTickFormatter
using ..ModelTypes: iDatetimeTicker
using ..ModelTypes: iDaysTicker, iSingleIntervalTicker
using ..ModelTypes: iDiv, iMarkup
using ..ModelTypes: iDodge
using ..ModelTypes: iDropdown
using ..ModelTypes: iEdgeCoordinates, iGraphCoordinates
using ..ModelTypes: iEdgesAndLinkedNodes, iGraphHitTestPolicy
using ..ModelTypes: iEdgesOnly
using ..ModelTypes: iEditTool
using ..ModelTypes: iEllipse
using ..ModelTypes: iEqHistColorMapper, iScanningColorMapper
using ..ModelTypes: iFactorRange
using ..ModelTypes: iFileInput
using ..ModelTypes: iFillGlyph
using ..ModelTypes: iFixedTicker
using ..ModelTypes: iFreehandDrawTool
using ..ModelTypes: iFuncTickFormatter
using ..ModelTypes: iGMapOptions, iMapOptions
using ..ModelTypes: iGMapPlot, iMapPlot, iPlot
using ..ModelTypes: iGeoJSONDataSource
using ..ModelTypes: iGlyphRenderer
using ..ModelTypes: iGraphRenderer
using ..ModelTypes: iGrid
using ..ModelTypes: iGridBox
using ..ModelTypes: iGroupFilter
using ..ModelTypes: iGroupingInfo
using ..ModelTypes: iHArea
using ..ModelTypes: iHBar
using ..ModelTypes: iHTMLBox
using ..ModelTypes: iHTMLTemplateFormatter
using ..ModelTypes: iHatchGlyph
using ..ModelTypes: iHelpTool
using ..ModelTypes: iHexTile
using ..ModelTypes: iHoverTool
using ..ModelTypes: iImage
using ..ModelTypes: iImageRGBA
using ..ModelTypes: iImageURL
using ..ModelTypes: iImageURLTexture
using ..ModelTypes: iIndexFilter
using ..ModelTypes: iIntEditor
using ..ModelTypes: iInterpolator
using ..ModelTypes: iIntersectRenderers, iSelectionPolicy
using ..ModelTypes: iJitter
using ..ModelTypes: iLabel, iTextAnnotation
using ..ModelTypes: iLabelSet
using ..ModelTypes: iLassoSelectTool
using ..ModelTypes: iLayoutProvider
using ..ModelTypes: iLegend
using ..ModelTypes: iLegendItem
using ..ModelTypes: iLine
using ..ModelTypes: iLineEditTool
using ..ModelTypes: iLinearColorMapper
using ..ModelTypes: iLinearInterpolator
using ..ModelTypes: iLinearScale
using ..ModelTypes: iLogAxis
using ..ModelTypes: iLogColorMapper
using ..ModelTypes: iLogScale
using ..ModelTypes: iLogTickFormatter
using ..ModelTypes: iLogTicker
using ..ModelTypes: iMathML
using ..ModelTypes: iMaxAggregator
using ..ModelTypes: iMaximum, iScalarExpression
using ..ModelTypes: iMercatorAxis
using ..ModelTypes: iMercatorTickFormatter
using ..ModelTypes: iMercatorTicker
using ..ModelTypes: iMinAggregator
using ..ModelTypes: iMinimum
using ..ModelTypes: iMonthsTicker
using ..ModelTypes: iMultiChoice
using ..ModelTypes: iMultiLine
using ..ModelTypes: iMultiPolygons
using ..ModelTypes: iMultiSelect
using ..ModelTypes: iNoOverlap
using ..ModelTypes: iNodeCoordinates
using ..ModelTypes: iNodesAndLinkedEdges
using ..ModelTypes: iNodesOnly
using ..ModelTypes: iNormalHead
using ..ModelTypes: iNumberEditor
using ..ModelTypes: iNumberFormatter
using ..ModelTypes: iNumeralTickFormatter
using ..ModelTypes: iNumericInput
using ..ModelTypes: iOpenHead
using ..ModelTypes: iOpenURL
using ..ModelTypes: iOval
using ..ModelTypes: iPanTool
using ..ModelTypes: iPanel
using ..ModelTypes: iParagraph
using ..ModelTypes: iPasswordInput
using ..ModelTypes: iPatch
using ..ModelTypes: iPatches
using ..ModelTypes: iPercentEditor
using ..ModelTypes: iPlainText
using ..ModelTypes: iPointDrawTool
using ..ModelTypes: iPolarTransform
using ..ModelTypes: iPolyAnnotation
using ..ModelTypes: iPolyDrawTool
using ..ModelTypes: iPolyEditTool
using ..ModelTypes: iPolySelectTool
using ..ModelTypes: iPolyTool
using ..ModelTypes: iPreText
using ..ModelTypes: iPrintfTickFormatter
using ..ModelTypes: iProxyToolbar, iToolbarBase
using ..ModelTypes: iQUADKEYTileSource
using ..ModelTypes: iQuad
using ..ModelTypes: iQuadratic
using ..ModelTypes: iRadioButtonGroup
using ..ModelTypes: iRadioGroup
using ..ModelTypes: iRange1d
using ..ModelTypes: iRangeSlider
using ..ModelTypes: iRangeTool
using ..ModelTypes: iRay
using ..ModelTypes: iRect
using ..ModelTypes: iRedoTool
using ..ModelTypes: iRendererGroup
using ..ModelTypes: iResetTool
using ..ModelTypes: iRow
using ..ModelTypes: iSaveTool
using ..ModelTypes: iScatter
using ..ModelTypes: iScientificFormatter
using ..ModelTypes: iScroll
using ..ModelTypes: iSegment
using ..ModelTypes: iSelect
using ..ModelTypes: iSelectEditor
using ..ModelTypes: iSelectTool
using ..ModelTypes: iSelection
using ..ModelTypes: iServerSentDataSource
using ..ModelTypes: iSlider
using ..ModelTypes: iSlope
using ..ModelTypes: iSpacer
using ..ModelTypes: iSpan
using ..ModelTypes: iSpinner
using ..ModelTypes: iStack
using ..ModelTypes: iStaticLayoutProvider
using ..ModelTypes: iStep
using ..ModelTypes: iStepInterpolator
using ..ModelTypes: iStringEditor
using ..ModelTypes: iSumAggregator
using ..ModelTypes: iTMSTileSource
using ..ModelTypes: iTableColumn
using ..ModelTypes: iTabs
using ..ModelTypes: iTap
using ..ModelTypes: iTapTool
using ..ModelTypes: iTeX
using ..ModelTypes: iTeeHead
using ..ModelTypes: iText
using ..ModelTypes: iTextAreaInput
using ..ModelTypes: iTextEditor
using ..ModelTypes: iTextGlyph
using ..ModelTypes: iTileRenderer
using ..ModelTypes: iTimeEditor
using ..ModelTypes: iTitle
using ..ModelTypes: iToggle
using ..ModelTypes: iToolbar
using ..ModelTypes: iToolbarBox
using ..ModelTypes: iToolbarPanel
using ..ModelTypes: iTooltip
using ..ModelTypes: iUndoTool
using ..ModelTypes: iUnionRenderers
using ..ModelTypes: iVArea
using ..ModelTypes: iVBar
using ..ModelTypes: iVeeHead
using ..ModelTypes: iWMTSTileSource
using ..ModelTypes: iWedge
using ..ModelTypes: iWheelPanTool
using ..ModelTypes: iWheelZoomTool
using ..ModelTypes: iWhisker
using ..ModelTypes: iWidgetBox
using ..ModelTypes: iXComponent, iXYComponent
using ..ModelTypes: iYComponent
using ..ModelTypes: iYearsTicker
using ..ModelTypes: iZoomInTool
using ..ModelTypes: iZoomOutTool
using ..ModelTypes: iStyles
using ..ModelTypes: iDOMAction
using ..ModelTypes: iDOMColorRef, iValueRef, iPlaceholder, iDOMNode
using ..ModelTypes: iDOMElement
using ..ModelTypes: iDOMDiv
using ..ModelTypes: iDOMIndex
using ..ModelTypes: iDOMPlaceholder
using ..ModelTypes: iDOMSpan
using ..ModelTypes: iDOMTable
using ..ModelTypes: iDOMTableRow
using ..ModelTypes: iDOMTemplate
using ..ModelTypes: iDOMText
using ..ModelTypes: iDOMToggleGroup, iAction
using ..ModelTypes: iDOMValueRef
const iTemplate = String
include("models/actiontool.jl")
include("models/adaptiveticker.jl")
include("models/ajaxdatasource.jl")
include("models/alllabels.jl")
include("models/annotation.jl")
include("models/annularwedge.jl")
include("models/annulus.jl")
include("models/arc.jl")
include("models/arrow.jl")
include("models/arrowhead.jl")
include("models/ascii.jl")
include("models/autocompleteinput.jl")
include("models/avgaggregator.jl")
include("models/axis.jl")
include("models/bboxtilesource.jl")
include("models/band.jl")
include("models/basetext.jl")
include("models/basictickformatter.jl")
include("models/basicticker.jl")
include("models/bezier.jl")
include("models/binnedticker.jl")
include("models/booleanfilter.jl")
include("models/booleanformatter.jl")
include("models/box.jl")
include("models/boxannotation.jl")
include("models/boxedittool.jl")
include("models/boxselecttool.jl")
include("models/boxzoomtool.jl")
include("models/button.jl")
include("models/buttongroup.jl")
include("models/cdsview.jl")
include("models/callback.jl")
include("models/canvastexture.jl")
include("models/categoricalaxis.jl")
include("models/categoricalcolormapper.jl")
include("models/categoricalmapper.jl")
include("models/categoricalmarkermapper.jl")
include("models/categoricalpatternmapper.jl")
include("models/categoricalscale.jl")
include("models/categoricaltickformatter.jl")
include("models/categoricalticker.jl")
include("models/celleditor.jl")
include("models/cellformatter.jl")
include("models/checkboxbuttongroup.jl")
include("models/checkboxeditor.jl")
include("models/checkboxgroup.jl")
include("models/circle.jl")
include("models/colorbar.jl")
include("models/colormapper.jl")
include("models/colorpicker.jl")
include("models/column.jl")
include("models/columndatasource.jl")
include("models/columnardatasource.jl")
include("models/compositeticker.jl")
include("models/connectedxyglyph.jl")
include("models/continuousaxis.jl")
include("models/continuouscolormapper.jl")
include("models/continuousscale.jl")
include("models/continuousticker.jl")
include("models/coordinatemapping.jl")
include("models/coordinatetransform.jl")
include("models/crosshairtool.jl")
include("models/cumsum.jl")
include("models/customaction.jl")
include("models/customjs.jl")
include("models/customjsexpr.jl")
include("models/customjsfilter.jl")
include("models/customjshover.jl")
include("models/customjstransform.jl")
include("models/customlabelingpolicy.jl")
include("models/dataannotation.jl")
include("models/datacube.jl")
include("models/datamodel.jl")
include("models/datarange.jl")
include("models/datarange1d.jl")
include("models/datarenderer.jl")
include("models/datasource.jl")
include("models/datatable.jl")
include("models/dateeditor.jl")
include("models/dateformatter.jl")
include("models/datepicker.jl")
include("models/daterangeslider.jl")
include("models/dateslider.jl")
include("models/datetimeaxis.jl")
include("models/datetimerangeslider.jl")
include("models/datetimetickformatter.jl")
include("models/datetimeticker.jl")
include("models/daysticker.jl")
include("models/div.jl")
include("models/dodge.jl")
include("models/drag.jl")
include("models/dropdown.jl")
include("models/edgecoordinates.jl")
include("models/edgesandlinkednodes.jl")
include("models/edgesonly.jl")
include("models/edittool.jl")
include("models/ellipse.jl")
include("models/eqhistcolormapper.jl")
include("models/expression.jl")
include("models/factorrange.jl")
include("models/fileinput.jl")
include("models/fillglyph.jl")
include("models/filter.jl")
include("models/fixedticker.jl")
include("models/freehanddrawtool.jl")
include("models/functickformatter.jl")
include("models/gmapoptions.jl")
include("models/gmapplot.jl")
include("models/geojsondatasource.jl")
include("models/gesturetool.jl")
include("models/glyph.jl")
include("models/glyphrenderer.jl")
include("models/graphcoordinates.jl")
include("models/graphhittestpolicy.jl")
include("models/graphrenderer.jl")
include("models/grid.jl")
include("models/gridbox.jl")
include("models/group.jl")
include("models/groupfilter.jl")
include("models/groupinginfo.jl")
include("models/guiderenderer.jl")
include("models/harea.jl")
include("models/hbar.jl")
include("models/htmlbox.jl")
include("models/htmltemplateformatter.jl")
include("models/hatchglyph.jl")
include("models/helptool.jl")
include("models/hextile.jl")
include("models/hovertool.jl")
include("models/image.jl")
include("models/imagergba.jl")
include("models/imageurl.jl")
include("models/imageurltexture.jl")
include("models/indexfilter.jl")
include("models/inputwidget.jl")
include("models/inspecttool.jl")
include("models/inteditor.jl")
include("models/interpolator.jl")
include("models/intersectrenderers.jl")
include("models/jitter.jl")
include("models/label.jl")
include("models/labelset.jl")
include("models/labelingpolicy.jl")
include("models/lassoselecttool.jl")
include("models/layoutdom.jl")
include("models/layoutprovider.jl")
include("models/legend.jl")
include("models/legenditem.jl")
include("models/line.jl")
include("models/lineedittool.jl")
include("models/lineglyph.jl")
include("models/linearaxis.jl")
include("models/linearcolormapper.jl")
include("models/linearinterpolator.jl")
include("models/linearscale.jl")
include("models/logaxis.jl")
include("models/logcolormapper.jl")
include("models/logscale.jl")
include("models/logtickformatter.jl")
include("models/logticker.jl")
include("models/mapoptions.jl")
include("models/mapplot.jl")
include("models/mapper.jl")
include("models/marker.jl")
include("models/markup.jl")
include("models/mathml.jl")
include("models/mathtext.jl")
include("models/maxaggregator.jl")
include("models/maximum.jl")
include("models/mercatoraxis.jl")
include("models/mercatortickformatter.jl")
include("models/mercatorticker.jl")
include("models/mercatortilesource.jl")
include("models/minaggregator.jl")
include("models/minimum.jl")
include("models/monthsticker.jl")
include("models/multichoice.jl")
include("models/multiline.jl")
include("models/multipolygons.jl")
include("models/multiselect.jl")
include("models/nooverlap.jl")
include("models/nodecoordinates.jl")
include("models/nodesandlinkededges.jl")
include("models/nodesonly.jl")
include("models/normalhead.jl")
include("models/numbereditor.jl")
include("models/numberformatter.jl")
include("models/numeraltickformatter.jl")
include("models/numericinput.jl")
include("models/openhead.jl")
include("models/openurl.jl")
include("models/oval.jl")
include("models/pantool.jl")
include("models/panel.jl")
include("models/paragraph.jl")
include("models/passwordinput.jl")
include("models/patch.jl")
include("models/patches.jl")
include("models/percenteditor.jl")
include("models/plaintext.jl")
include("models/plot.jl")
include("models/pointdrawtool.jl")
include("models/polartransform.jl")
include("models/polyannotation.jl")
include("models/polydrawtool.jl")
include("models/polyedittool.jl")
include("models/polyselecttool.jl")
include("models/polytool.jl")
include("models/pretext.jl")
include("models/printftickformatter.jl")
include("models/proxytoolbar.jl")
include("models/quadkeytilesource.jl")
include("models/quad.jl")
include("models/quadratic.jl")
include("models/radiobuttongroup.jl")
include("models/radiogroup.jl")
include("models/range.jl")
include("models/range1d.jl")
include("models/rangeslider.jl")
include("models/rangetool.jl")
include("models/ray.jl")
include("models/rect.jl")
include("models/redotool.jl")
include("models/renderer.jl")
include("models/renderergroup.jl")
include("models/resettool.jl")
include("models/row.jl")
include("models/rowaggregator.jl")
include("models/savetool.jl")
include("models/scalarexpression.jl")
include("models/scale.jl")
include("models/scanningcolormapper.jl")
include("models/scatter.jl")
include("models/scientificformatter.jl")
include("models/scroll.jl")
include("models/segment.jl")
include("models/select.jl")
include("models/selecteditor.jl")
include("models/selecttool.jl")
include("models/selection.jl")
include("models/selectionpolicy.jl")
include("models/serversentdatasource.jl")
include("models/singleintervalticker.jl")
include("models/slider.jl")
include("models/slope.jl")
include("models/spacer.jl")
include("models/span.jl")
include("models/spinner.jl")
include("models/stack.jl")
include("models/staticlayoutprovider.jl")
include("models/step.jl")
include("models/stepinterpolator.jl")
include("models/stringeditor.jl")
include("models/stringformatter.jl")
include("models/sumaggregator.jl")
include("models/tmstilesource.jl")
include("models/tablecolumn.jl")
include("models/tablewidget.jl")
include("models/tabs.jl")
include("models/tap.jl")
include("models/taptool.jl")
include("models/tex.jl")
include("models/teehead.jl")
include("models/text.jl")
include("models/textannotation.jl")
include("models/textareainput.jl")
include("models/texteditor.jl")
include("models/textglyph.jl")
include("models/textinput.jl")
include("models/textlikeinput.jl")
include("models/texture.jl")
include("models/tickformatter.jl")
include("models/ticker.jl")
include("models/tilerenderer.jl")
include("models/tilesource.jl")
include("models/timeeditor.jl")
include("models/title.jl")
include("models/toggle.jl")
include("models/tool.jl")
include("models/toolbar.jl")
include("models/toolbarbase.jl")
include("models/toolbarbox.jl")
include("models/toolbarpanel.jl")
include("models/tooltip.jl")
include("models/transform.jl")
include("models/undotool.jl")
include("models/unionrenderers.jl")
include("models/varea.jl")
include("models/vbar.jl")
include("models/veehead.jl")
include("models/wmtstilesource.jl")
include("models/webdatasource.jl")
include("models/wedge.jl")
include("models/wheelpantool.jl")
include("models/wheelzoomtool.jl")
include("models/whisker.jl")
include("models/widget.jl")
include("models/widgetbox.jl")
include("models/xcomponent.jl")
include("models/xycomponent.jl")
include("models/xyglyph.jl")
include("models/ycomponent.jl")
include("models/yearsticker.jl")
include("models/zoomintool.jl")
include("models/zoomouttool.jl")
include("models/styles.jl")
include("models/domaction.jl")
include("models/domcolorref.jl")
include("models/domelement.jl")
include("models/domnode.jl")
include("models/domdiv.jl")
include("models/domindex.jl")
include("models/domplaceholder.jl")
include("models/domspan.jl")
include("models/domtable.jl")
include("models/domtablerow.jl")
include("models/domtemplate.jl")
include("models/domtext.jl")
include("models/domtogglegroup.jl")
include("models/domvalueref.jl")
end
