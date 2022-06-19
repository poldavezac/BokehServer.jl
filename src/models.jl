#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#
#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#
module Models
using Dates
using ..Bokeh
using ..Model
using ..AbstractTypes
using ..ModelTypes: iContinuousTicker, iTicker, iModel
using ..ModelTypes: iDOMSpan, iDOMElement, iDOMNode
using ..ModelTypes: iSelectTool, iGestureTool, iTool
using ..ModelTypes: iAbstractIcon
using ..ModelTypes: iImageRGBA, iXYGlyph, iGlyph
using ..ModelTypes: iLegendItem
using ..ModelTypes: iPolyAnnotation, iAnnotation, iRenderer
using ..ModelTypes: iYearsTicker, iSingleIntervalTicker
using ..ModelTypes: iHelpTool, iActionTool
using ..ModelTypes: iNormalHead, iArrowHead
using ..ModelTypes: iText
using ..ModelTypes: iPanTool, iDrag
using ..ModelTypes: iHoverTool, iInspectTool
using ..ModelTypes: iFillGlyph
using ..ModelTypes: iStringEditor, iCellEditor
using ..ModelTypes: iGMapOptions, iMapOptions
using ..ModelTypes: iScale, iTransform
using ..ModelTypes: iWedge
using ..ModelTypes: iDataTable, iTableWidget, iWidget, iLayoutDOM
using ..ModelTypes: iTMSTileSource, iMercatorTileSource, iTileSource
using ..ModelTypes: iTableColumn
using ..ModelTypes: iScroll
using ..ModelTypes: iRowAggregator
using ..ModelTypes: iPlainText, iBaseText
using ..ModelTypes: iDOMColorRef, iValueRef, iPlaceholder
using ..ModelTypes: iConnectedXYGlyph
using ..ModelTypes: iMercatorTickFormatter, iBasicTickFormatter, iTickFormatter
using ..ModelTypes: iGraphHitTestPolicy
using ..ModelTypes: iXComponent, iXYComponent, iExpression
using ..ModelTypes: iLabel, iTextAnnotation
using ..ModelTypes: iDateSlider, iAbstractSlider
using ..ModelTypes: iInputWidget
using ..ModelTypes: iYComponent
using ..ModelTypes: iSpacer
using ..ModelTypes: iJitter
using ..ModelTypes: iZoomOutTool
using ..ModelTypes: iAbstractGroup
using ..ModelTypes: iColumnDataSource, iColumnarDataSource, iDataSource
using ..ModelTypes: iDaysTicker
using ..ModelTypes: iHexTile
using ..ModelTypes: iWidgetBox, iColumn, iBox
using ..ModelTypes: iLinearScale, iContinuousScale
using ..ModelTypes: iCircle, iMarker
using ..ModelTypes: iFileInput
using ..ModelTypes: iRedoTool
using ..ModelTypes: iNodesAndLinkedEdges
using ..ModelTypes: iCategoricalColorMapper, iMapper
using ..ModelTypes: iMultiPolygons
using ..ModelTypes: iCumSum
using ..ModelTypes: iSlider
using ..ModelTypes: iPatch
using ..ModelTypes: iMultiChoice
using ..ModelTypes: iSpan
using ..ModelTypes: iBoxAnnotation
using ..ModelTypes: iTextAreaInput, iTextLikeInput
using ..ModelTypes: iGuideRenderer
using ..ModelTypes: iLinearAxis, iContinuousAxis, iAxis
using ..ModelTypes: iAnnularWedge
using ..ModelTypes: iDOMTemplate
using ..ModelTypes: iCategoricalTickFormatter
using ..ModelTypes: iDatetimeRangeSlider
using ..ModelTypes: iNodeCoordinates, iGraphCoordinates, iCoordinateTransform
using ..ModelTypes: iRangeTool
using ..ModelTypes: iNumberEditor
using ..ModelTypes: iGMapPlot, iMapPlot, iPlot
using ..ModelTypes: iCrosshairTool
using ..ModelTypes: iBooleanFormatter, iCellFormatter
using ..ModelTypes: iEllipse
using ..ModelTypes: iBoxZoomTool
using ..ModelTypes: iColorMapper
using ..ModelTypes: iArrow, iDataAnnotation
using ..ModelTypes: iDOMDiv
using ..ModelTypes: iCanvasTexture, iTexture
using ..ModelTypes: iOval
using ..ModelTypes: iAllLabels, iLabelingPolicy
using ..ModelTypes: iGeoJSONDataSource
using ..ModelTypes: iMinAggregator
using ..ModelTypes: iDOMPlaceholder
using ..ModelTypes: iMaxAggregator
using ..ModelTypes: iMathText
using ..ModelTypes: iTileRenderer
using ..ModelTypes: iImageURL
using ..ModelTypes: iPreText, iParagraph, iMarkup
using ..ModelTypes: iDropdown, iAbstractButton
using ..ModelTypes: iAutocompleteInput, iTextInput
using ..ModelTypes: iAscii
using ..ModelTypes: iIndexFilter, iFilter
using ..ModelTypes: iPrintfTickFormatter
using ..ModelTypes: iCDSView
using ..ModelTypes: iCustomJSExpr
using ..ModelTypes: iToolbarPanel
using ..ModelTypes: iCallback
using ..ModelTypes: iCustomJSTransform
using ..ModelTypes: iNumberFormatter, iStringFormatter
using ..ModelTypes: iContinuousColorMapper
using ..ModelTypes: iRange1d, iRange
using ..ModelTypes: iPolarTransform
using ..ModelTypes: iVeeHead
using ..ModelTypes: iLinearColorMapper
using ..ModelTypes: iSelection
using ..ModelTypes: iStep
using ..ModelTypes: iSpinner, iNumericInput
using ..ModelTypes: iMinimum, iScalarExpression
using ..ModelTypes: iHatchGlyph
using ..ModelTypes: iDOMTable
using ..ModelTypes: iRadioButtonGroup, iButtonGroup
using ..ModelTypes: iTextGlyph
using ..ModelTypes: iCompositeTicker
using ..ModelTypes: iBand
using ..ModelTypes: iRay
using ..ModelTypes: iUnionRenderers, iSelectionPolicy
using ..ModelTypes: iLineEditTool
using ..ModelTypes: iTitle
using ..ModelTypes: iRendererGroup
using ..ModelTypes: iCategoricalMarkerMapper, iCategoricalMapper
using ..ModelTypes: iDOMToggleGroup, iAction
using ..ModelTypes: iFixedTicker
using ..ModelTypes: iPasswordInput
using ..ModelTypes: iServerSentDataSource, iWebDataSource
using ..ModelTypes: iQUADKEYTileSource
using ..ModelTypes: iCheckboxButtonGroup
using ..ModelTypes: iLogTicker, iAdaptiveTicker
using ..ModelTypes: iEdgeCoordinates
using ..ModelTypes: iCategoricalAxis
using ..ModelTypes: iStyles
using ..ModelTypes: iTimeEditor
using ..ModelTypes: iSaveTool
using ..ModelTypes: iDatetimeAxis
using ..ModelTypes: iLinearInterpolator, iInterpolator
using ..ModelTypes: iDOMValueRef
using ..ModelTypes: iToolbarBox
using ..ModelTypes: iCheckboxEditor
using ..ModelTypes: iImage
using ..ModelTypes: iVBar
using ..ModelTypes: iLineGlyph
using ..ModelTypes: iTooltip
using ..ModelTypes: iDOMTableRow
using ..ModelTypes: iGroup
using ..ModelTypes: iQuad
using ..ModelTypes: iPanel
using ..ModelTypes: iUndoTool
using ..ModelTypes: iToggle
using ..ModelTypes: iTap
using ..ModelTypes: iCoordinateMapping
using ..ModelTypes: iDataModel
using ..ModelTypes: iArc
using ..ModelTypes: iDataRange
using ..ModelTypes: iScientificFormatter
using ..ModelTypes: iVArea
using ..ModelTypes: iNoOverlap
using ..ModelTypes: iMathML
using ..ModelTypes: iBasicTicker
using ..ModelTypes: iGraphRenderer, iDataRenderer
using ..ModelTypes: iMaximum
using ..ModelTypes: iDatePicker
using ..ModelTypes: iCustomJS
using ..ModelTypes: iColorBar
using ..ModelTypes: iToolbar, iToolbarBase
using ..ModelTypes: iEditTool
using ..ModelTypes: iHTMLBox
using ..ModelTypes: iLogColorMapper
using ..ModelTypes: iPolyDrawTool
using ..ModelTypes: iSumAggregator
using ..ModelTypes: iOpenHead
using ..ModelTypes: iPatches
using ..ModelTypes: iCategoricalPatternMapper
using ..ModelTypes: iLabelSet
using ..ModelTypes: iBezier
using ..ModelTypes: iDateFormatter
using ..ModelTypes: iPointDrawTool
using ..ModelTypes: iBinnedTicker
using ..ModelTypes: iDOMAction
using ..ModelTypes: iHArea
using ..ModelTypes: iWhisker
using ..ModelTypes: iLassoSelectTool
using ..ModelTypes: iButton
using ..ModelTypes: iNodesOnly
using ..ModelTypes: iTextEditor
using ..ModelTypes: iTapTool
using ..ModelTypes: iStaticLayoutProvider, iLayoutProvider
using ..ModelTypes: iDataRange1d
using ..ModelTypes: iDOMIndex
using ..ModelTypes: iBooleanFilter
using ..ModelTypes: iDatetimeTicker
using ..ModelTypes: iStack
using ..ModelTypes: iDodge
using ..ModelTypes: iQuadratic
using ..ModelTypes: iColorPicker
using ..ModelTypes: iLegend
using ..ModelTypes: iGroupingInfo
using ..ModelTypes: iCustomAction
using ..ModelTypes: iBoxEditTool
using ..ModelTypes: iPolyTool
using ..ModelTypes: iCustomJSHover
using ..ModelTypes: iIntersectRenderers
using ..ModelTypes: iWheelPanTool
using ..ModelTypes: iSelectEditor
using ..ModelTypes: iFactorRange
using ..ModelTypes: iTeeHead
using ..ModelTypes: iHTMLTemplateFormatter
using ..ModelTypes: iEqHistColorMapper, iScanningColorMapper
using ..ModelTypes: iLogAxis
using ..ModelTypes: iGroupFilter
using ..ModelTypes: iAjaxDataSource
using ..ModelTypes: iWheelZoomTool
using ..ModelTypes: iDateRangeSlider
using ..ModelTypes: iMercatorTicker
using ..ModelTypes: iHBar
using ..ModelTypes: iDateEditor
using ..ModelTypes: iMultiLine
using ..ModelTypes: iScatter
using ..ModelTypes: iCustomJSFilter
using ..ModelTypes: iResetTool
using ..ModelTypes: iRadioGroup
using ..ModelTypes: iRangeSlider
using ..ModelTypes: iTabs
using ..ModelTypes: iGlyphRenderer
using ..ModelTypes: iBBoxTileSource
using ..ModelTypes: iEdgesAndLinkedNodes
using ..ModelTypes: iPercentEditor
using ..ModelTypes: iSlope
using ..ModelTypes: iRect
using ..ModelTypes: iAnnulus
using ..ModelTypes: iFuncTickFormatter
using ..ModelTypes: iProxyToolbar
using ..ModelTypes: iImageURLTexture
using ..ModelTypes: iOpenURL
using ..ModelTypes: iCategoricalTicker
using ..ModelTypes: iIntEditor
using ..ModelTypes: iSelect
using ..ModelTypes: iWMTSTileSource
using ..ModelTypes: iAvgAggregator
using ..ModelTypes: iLine
using ..ModelTypes: iMultiSelect
using ..ModelTypes: iLogTickFormatter
using ..ModelTypes: iGridBox
using ..ModelTypes: iZoomInTool
using ..ModelTypes: iBoxSelectTool
using ..ModelTypes: iRow
using ..ModelTypes: iPolySelectTool
using ..ModelTypes: iGrid
using ..ModelTypes: iNumeralTickFormatter
using ..ModelTypes: iEdgesOnly
using ..ModelTypes: iFreehandDrawTool
using ..ModelTypes: iCategoricalScale
using ..ModelTypes: iMercatorAxis
using ..ModelTypes: iCheckboxGroup
using ..ModelTypes: iSegment
using ..ModelTypes: iDatetimeTickFormatter
using ..ModelTypes: iPolyEditTool
using ..ModelTypes: iStepInterpolator
using ..ModelTypes: iDOMText
using ..ModelTypes: iDataCube
using ..ModelTypes: iMonthsTicker
using ..ModelTypes: iCustomLabelingPolicy
using ..ModelTypes: iDiv
using ..ModelTypes: iLogScale
using ..ModelTypes: iTeX
const iTemplate = String
include("models/continuousticker.jl")
include("models/domspan.jl")
include("models/selecttool.jl")
include("models/imagergba.jl")
include("models/legenditem.jl")
include("models/polyannotation.jl")
include("models/yearsticker.jl")
include("models/helptool.jl")
include("models/normalhead.jl")
include("models/text.jl")
include("models/pantool.jl")
include("models/hovertool.jl")
include("models/fillglyph.jl")
include("models/stringeditor.jl")
include("models/gmapoptions.jl")
include("models/scale.jl")
include("models/wedge.jl")
include("models/datatable.jl")
include("models/tmstilesource.jl")
include("models/layoutdom.jl")
include("models/tablecolumn.jl")
include("models/scroll.jl")
include("models/rowaggregator.jl")
include("models/plaintext.jl")
include("models/domcolorref.jl")
include("models/connectedxyglyph.jl")
include("models/mercatortickformatter.jl")
include("models/graphhittestpolicy.jl")
include("models/xcomponent.jl")
include("models/label.jl")
include("models/dateslider.jl")
include("models/inputwidget.jl")
include("models/ycomponent.jl")
include("models/spacer.jl")
include("models/jitter.jl")
include("models/zoomouttool.jl")
include("models/mapoptions.jl")
include("models/columndatasource.jl")
include("models/singleintervalticker.jl")
include("models/daysticker.jl")
include("models/hextile.jl")
include("models/widgetbox.jl")
include("models/linearscale.jl")
include("models/circle.jl")
include("models/fileinput.jl")
include("models/redotool.jl")
include("models/nodesandlinkededges.jl")
include("models/categoricalcolormapper.jl")
include("models/multipolygons.jl")
include("models/cumsum.jl")
include("models/slider.jl")
include("models/patch.jl")
include("models/multichoice.jl")
include("models/span.jl")
include("models/boxannotation.jl")
include("models/textareainput.jl")
include("models/guiderenderer.jl")
include("models/linearaxis.jl")
include("models/annularwedge.jl")
include("models/domtemplate.jl")
include("models/categoricaltickformatter.jl")
include("models/datetimerangeslider.jl")
include("models/nodecoordinates.jl")
include("models/rangetool.jl")
include("models/numbereditor.jl")
include("models/gmapplot.jl")
include("models/crosshairtool.jl")
include("models/booleanformatter.jl")
include("models/ellipse.jl")
include("models/boxzoomtool.jl")
include("models/colormapper.jl")
include("models/arrow.jl")
include("models/domdiv.jl")
include("models/canvastexture.jl")
include("models/oval.jl")
include("models/alllabels.jl")
include("models/geojsondatasource.jl")
include("models/minaggregator.jl")
include("models/domplaceholder.jl")
include("models/transform.jl")
include("models/maxaggregator.jl")
include("models/mathtext.jl")
include("models/tilerenderer.jl")
include("models/imageurl.jl")
include("models/glyph.jl")
include("models/pretext.jl")
include("models/dropdown.jl")
include("models/autocompleteinput.jl")
include("models/ascii.jl")
include("models/indexfilter.jl")
include("models/labelingpolicy.jl")
include("models/tilesource.jl")
include("models/column.jl")
include("models/printftickformatter.jl")
include("models/celleditor.jl")
include("models/cdsview.jl")
include("models/customjsexpr.jl")
include("models/toolbarpanel.jl")
include("models/plot.jl")
include("models/callback.jl")
include("models/customjstransform.jl")
include("models/numberformatter.jl")
include("models/continuouscolormapper.jl")
include("models/range1d.jl")
include("models/polartransform.jl")
include("models/veehead.jl")
include("models/mapplot.jl")
include("models/linearcolormapper.jl")
include("models/selection.jl")
include("models/step.jl")
include("models/spinner.jl")
include("models/minimum.jl")
include("models/hatchglyph.jl")
include("models/tool.jl")
include("models/domtable.jl")
include("models/radiobuttongroup.jl")
include("models/textglyph.jl")
include("models/compositeticker.jl")
include("models/band.jl")
include("models/ray.jl")
include("models/arrowhead.jl")
include("models/unionrenderers.jl")
include("models/basictickformatter.jl")
include("models/lineedittool.jl")
include("models/title.jl")
include("models/renderergroup.jl")
include("models/categoricalmarkermapper.jl")
include("models/inspecttool.jl")
include("models/mapper.jl")
include("models/domtogglegroup.jl")
include("models/fixedticker.jl")
include("models/passwordinput.jl")
include("models/serversentdatasource.jl")
include("models/quadkeytilesource.jl")
include("models/checkboxbuttongroup.jl")
include("models/paragraph.jl")
include("models/logticker.jl")
include("models/edgecoordinates.jl")
include("models/categoricalaxis.jl")
include("models/cellformatter.jl")
include("models/styles.jl")
include("models/selectionpolicy.jl")
include("models/expression.jl")
include("models/timeeditor.jl")
include("models/savetool.jl")
include("models/basetext.jl")
include("models/datetimeaxis.jl")
include("models/linearinterpolator.jl")
include("models/domvalueref.jl")
include("models/toolbarbox.jl")
include("models/checkboxeditor.jl")
include("models/image.jl")
include("models/vbar.jl")
include("models/datasource.jl")
include("models/actiontool.jl")
include("models/lineglyph.jl")
include("models/domelement.jl")
include("models/renderer.jl")
include("models/tooltip.jl")
include("models/domtablerow.jl")
include("models/group.jl")
include("models/quad.jl")
include("models/interpolator.jl")
include("models/panel.jl")
include("models/mercatortilesource.jl")
include("models/undotool.jl")
include("models/toggle.jl")
include("models/tap.jl")
include("models/coordinatemapping.jl")
include("models/axis.jl")
include("models/datamodel.jl")
include("models/arc.jl")
include("models/datarange.jl")
include("models/xycomponent.jl")
include("models/scientificformatter.jl")
include("models/varea.jl")
include("models/nooverlap.jl")
include("models/mathml.jl")
include("models/basicticker.jl")
include("models/graphrenderer.jl")
include("models/maximum.jl")
include("models/tickformatter.jl")
include("models/datepicker.jl")
include("models/customjs.jl")
include("models/filter.jl")
include("models/colorbar.jl")
include("models/toolbar.jl")
include("models/edittool.jl")
include("models/webdatasource.jl")
include("models/htmlbox.jl")
include("models/logcolormapper.jl")
include("models/polydrawtool.jl")
include("models/sumaggregator.jl")
include("models/openhead.jl")
include("models/patches.jl")
include("models/categoricalpatternmapper.jl")
include("models/labelset.jl")
include("models/bezier.jl")
include("models/dateformatter.jl")
include("models/pointdrawtool.jl")
include("models/binnedticker.jl")
include("models/gesturetool.jl")
include("models/textinput.jl")
include("models/domaction.jl")
include("models/graphcoordinates.jl")
include("models/harea.jl")
include("models/whisker.jl")
include("models/lassoselecttool.jl")
include("models/button.jl")
include("models/nodesonly.jl")
include("models/texteditor.jl")
include("models/taptool.jl")
include("models/marker.jl")
include("models/staticlayoutprovider.jl")
include("models/toolbarbase.jl")
include("models/datarange1d.jl")
include("models/scalarexpression.jl")
include("models/annotation.jl")
include("models/domindex.jl")
include("models/booleanfilter.jl")
include("models/datetimeticker.jl")
include("models/stack.jl")
include("models/dodge.jl")
include("models/quadratic.jl")
include("models/colorpicker.jl")
include("models/textlikeinput.jl")
include("models/legend.jl")
include("models/groupinginfo.jl")
include("models/customaction.jl")
include("models/dataannotation.jl")
include("models/markup.jl")
include("models/boxedittool.jl")
include("models/layoutprovider.jl")
include("models/polytool.jl")
include("models/datarenderer.jl")
include("models/customjshover.jl")
include("models/domnode.jl")
include("models/intersectrenderers.jl")
include("models/wheelpantool.jl")
include("models/stringformatter.jl")
include("models/selecteditor.jl")
include("models/buttongroup.jl")
include("models/adaptiveticker.jl")
include("models/factorrange.jl")
include("models/continuousscale.jl")
include("models/teehead.jl")
include("models/continuousaxis.jl")
include("models/htmltemplateformatter.jl")
include("models/eqhistcolormapper.jl")
include("models/columnardatasource.jl")
include("models/logaxis.jl")
include("models/groupfilter.jl")
include("models/ajaxdatasource.jl")
include("models/texture.jl")
include("models/box.jl")
include("models/wheelzoomtool.jl")
include("models/daterangeslider.jl")
include("models/mercatorticker.jl")
include("models/hbar.jl")
include("models/dateeditor.jl")
include("models/multiline.jl")
include("models/categoricalmapper.jl")
include("models/scatter.jl")
include("models/customjsfilter.jl")
include("models/resettool.jl")
include("models/radiogroup.jl")
include("models/rangeslider.jl")
include("models/tabs.jl")
include("models/glyphrenderer.jl")
include("models/bboxtilesource.jl")
include("models/xyglyph.jl")
include("models/edgesandlinkednodes.jl")
include("models/numericinput.jl")
include("models/percenteditor.jl")
include("models/slope.jl")
include("models/rect.jl")
include("models/annulus.jl")
include("models/functickformatter.jl")
include("models/proxytoolbar.jl")
include("models/imageurltexture.jl")
include("models/openurl.jl")
include("models/ticker.jl")
include("models/categoricalticker.jl")
include("models/inteditor.jl")
include("models/select.jl")
include("models/wmtstilesource.jl")
include("models/avgaggregator.jl")
include("models/line.jl")
include("models/multiselect.jl")
include("models/logtickformatter.jl")
include("models/widget.jl")
include("models/gridbox.jl")
include("models/zoomintool.jl")
include("models/boxselecttool.jl")
include("models/row.jl")
include("models/polyselecttool.jl")
include("models/grid.jl")
include("models/numeraltickformatter.jl")
include("models/edgesonly.jl")
include("models/freehanddrawtool.jl")
include("models/coordinatetransform.jl")
include("models/categoricalscale.jl")
include("models/mercatoraxis.jl")
include("models/checkboxgroup.jl")
include("models/drag.jl")
include("models/segment.jl")
include("models/textannotation.jl")
include("models/datetimetickformatter.jl")
include("models/polyedittool.jl")
include("models/stepinterpolator.jl")
include("models/range.jl")
include("models/tablewidget.jl")
include("models/domtext.jl")
include("models/datacube.jl")
include("models/monthsticker.jl")
include("models/customlabelingpolicy.jl")
include("models/div.jl")
include("models/scanningcolormapper.jl")
include("models/logscale.jl")
include("models/tex.jl")
end
