#- file generated by BokehServer's 'CodeCreator': edit at your own risk! -#
abstract type iUIElement <: iModel end
abstract type iMenuItem <: iUIElement end
abstract type iUIAction <: iMenuItem end
abstract type iTicker <: iModel end
abstract type iContinuousTicker <: iTicker end
abstract type iAdaptiveTicker <: iContinuousTicker end
abstract type iDataSource <: iModel end
abstract type iColumnarDataSource <: iDataSource end
abstract type iColumnDataSource <: iColumnarDataSource end
abstract type iWebDataSource <: iColumnDataSource end
abstract type iAjaxDataSource <: iWebDataSource end
abstract type iFilter <: iModel end
abstract type iAllIndices <: iFilter end
abstract type iLabelingPolicy <: iModel end
abstract type iAllLabels <: iLabelingPolicy end
abstract type iGlyph <: iModel end
abstract type iAnnularWedge <: iGlyph end
abstract type iAnnulus <: iGlyph end
abstract type iArc <: iGlyph end
abstract type iRenderer <: iModel end
abstract type iAnnotation <: iRenderer end
abstract type iDataAnnotation <: iAnnotation end
abstract type iArrow <: iDataAnnotation end
abstract type iBaseText <: iModel end
abstract type iMathText <: iBaseText end
abstract type iAscii <: iMathText end
abstract type iLayoutDOM <: iUIElement end
abstract type iWidget <: iLayoutDOM end
abstract type iInputWidget <: iWidget end
abstract type iTextLikeInput <: iInputWidget end
abstract type iTextInput <: iTextLikeInput end
abstract type iAutocompleteInput <: iTextInput end
abstract type iRowAggregator <: iModel end
abstract type iAvgAggregator <: iRowAggregator end
abstract type iTileSource <: iModel end
abstract type iMercatorTileSource <: iTileSource end
abstract type iBBoxTileSource <: iMercatorTileSource end
abstract type iBand <: iDataAnnotation end
abstract type iTickFormatter <: iModel end
abstract type iBasicTickFormatter <: iTickFormatter end
abstract type iBasicTicker <: iAdaptiveTicker end
abstract type iLineGlyph <: iGlyph end
abstract type iBezier <: iLineGlyph end
abstract type iBinnedTicker <: iTicker end
abstract type iBlock <: iGlyph end
abstract type iBooleanFilter <: iFilter end
abstract type iCellFormatter <: iModel end
abstract type iBooleanFormatter <: iCellFormatter end
abstract type iBoxAnnotation <: iAnnotation end
abstract type iTool <: iModel end
abstract type iGestureTool <: iTool end
abstract type iBoxEditTool <: iGestureTool end
abstract type iBoxSelectTool <: iGestureTool end
abstract type iDrag <: iGestureTool end
abstract type iBoxZoomTool <: iDrag end
abstract type iIcon <: iModel end
abstract type iBuiltinIcon <: iIcon end
abstract type iAbstractButton <: iWidget end
abstract type iButton <: iAbstractButton end
abstract type iSelector <: iModel end
abstract type iByCSS <: iSelector end
abstract type iByClass <: iSelector end
abstract type iByID <: iSelector end
abstract type iByXPath <: iSelector end
abstract type iCDSView <: iModel end
abstract type iCanvas <: iUIElement end
abstract type iTexture <: iModel end
abstract type iCanvasTexture <: iTexture end
abstract type iGuideRenderer <: iRenderer end
abstract type iAxis <: iGuideRenderer end
abstract type iCategoricalAxis <: iAxis end
abstract type iTransform <: iModel end
abstract type iMapper <: iTransform end
abstract type iCategoricalColorMapper <: iMapper end
abstract type iCategoricalMapper <: iMapper end
abstract type iCategoricalMarkerMapper <: iCategoricalMapper end
abstract type iCategoricalPatternMapper <: iCategoricalMapper end
abstract type iScale <: iTransform end
abstract type iCategoricalScale <: iScale end
abstract type iCategoricalTickFormatter <: iTickFormatter end
abstract type iCategoricalTicker <: iTicker end
abstract type iCheckAction <: iUIAction end
abstract type iToggleInput <: iWidget end
abstract type iCheckbox <: iToggleInput end
abstract type iAbstractGroup <: iWidget end
abstract type iToggleButtonGroup <: iAbstractGroup end
abstract type iCheckboxButtonGroup <: iToggleButtonGroup end
abstract type iCellEditor <: iModel end
abstract type iCheckboxEditor <: iCellEditor end
abstract type iToggleInputGroup <: iAbstractGroup end
abstract type iCheckboxGroup <: iToggleInputGroup end
abstract type iMarker <: iGlyph end
abstract type iCircle <: iMarker end
abstract type iBaseColorBar <: iAnnotation end
abstract type iColorBar <: iBaseColorBar end
abstract type iColorPicker <: iInputWidget end
abstract type iFlexBox <: iLayoutDOM end
abstract type iColumn <: iFlexBox end
abstract type iCompositeTicker <: iContinuousTicker end
abstract type iContinuousScale <: iScale end
abstract type iContourColorBar <: iBaseColorBar end
abstract type iDataRenderer <: iRenderer end
abstract type iContourRenderer <: iDataRenderer end
abstract type iCoordinateMapping <: iModel end
abstract type iActionTool <: iTool end
abstract type iCopyTool <: iActionTool end
abstract type iInspectTool <: iGestureTool end
abstract type iCrosshairTool <: iInspectTool end
abstract type iExpression <: iModel end
abstract type iCumSum <: iExpression end
abstract type iCustomAction <: iActionTool end
abstract type iCallback <: iModel end
abstract type iCustomJS <: iCallback end
abstract type iCustomJSExpr <: iExpression end
abstract type iCustomJSFilter <: iFilter end
abstract type iCustomJSHover <: iModel end
abstract type iCustomJSTickFormatter <: iTickFormatter end
abstract type iCustomJSTransform <: iTransform end
abstract type iCustomLabelingPolicy <: iLabelingPolicy end
abstract type iTableWidget <: iWidget end
abstract type iDataTable <: iTableWidget end
abstract type iDataCube <: iDataTable end
abstract type iRange <: iModel end
abstract type iDataRange <: iRange end
abstract type iDataRange1d <: iDataRange end
abstract type iDateEditor <: iCellEditor end
abstract type iStringFormatter <: iCellFormatter end
abstract type iDateFormatter <: iStringFormatter end
abstract type iDatePicker <: iInputWidget end
abstract type iAbstractSlider <: iWidget end
abstract type iDateRangeSlider <: iAbstractSlider end
abstract type iDateSlider <: iAbstractSlider end
abstract type iContinuousAxis <: iAxis end
abstract type iLinearAxis <: iContinuousAxis end
abstract type iDatetimeAxis <: iLinearAxis end
abstract type iDatetimeRangeSlider <: iAbstractSlider end
abstract type iDatetimeTickFormatter <: iTickFormatter end
abstract type iDatetimeTicker <: iCompositeTicker end
abstract type iSingleIntervalTicker <: iContinuousTicker end
abstract type iDaysTicker <: iSingleIntervalTicker end
abstract type iDecoration <: iModel end
abstract type iDialog <: iUIElement end
abstract type iDifferenceFilter <: iFilter end
abstract type iMarkup <: iWidget end
abstract type iDiv <: iMarkup end
abstract type iDivider <: iMenuItem end
abstract type iDodge <: iTransform end
abstract type iDropdown <: iAbstractButton end
abstract type iCoordinateTransform <: iExpression end
abstract type iGraphCoordinates <: iCoordinateTransform end
abstract type iEdgeCoordinates <: iGraphCoordinates end
abstract type iGraphHitTestPolicy <: iModel end
abstract type iEdgesAndLinkedNodes <: iGraphHitTestPolicy end
abstract type iEdgesOnly <: iGraphHitTestPolicy end
abstract type iEllipse <: iGlyph end
abstract type iColorMapper <: iMapper end
abstract type iContinuousColorMapper <: iColorMapper end
abstract type iScanningColorMapper <: iContinuousColorMapper end
abstract type iEqHistColorMapper <: iScanningColorMapper end
abstract type iFactorRange <: iRange end
abstract type iFileInput <: iInputWidget end
abstract type iFixedTicker <: iContinuousTicker end
abstract type iFreehandDrawTool <: iGestureTool end
abstract type iFullscreenTool <: iActionTool end
abstract type iMapOptions <: iModel end
abstract type iGMapOptions <: iMapOptions end
abstract type iPlot <: iLayoutDOM end
abstract type iMapPlot <: iPlot end
abstract type iGMapPlot <: iMapPlot end
abstract type iGeoJSONDataSource <: iColumnarDataSource end
abstract type iGlyphRenderer <: iDataRenderer end
abstract type iGraphRenderer <: iDataRenderer end
abstract type iGrid <: iGuideRenderer end
abstract type iGridBox <: iLayoutDOM end
abstract type iGridPlot <: iLayoutDOM end
abstract type iGroupBox <: iLayoutDOM end
abstract type iGroupFilter <: iFilter end
abstract type iGroupingInfo <: iModel end
abstract type iHArea <: iGlyph end
abstract type iHBar <: iGlyph end
abstract type iHBox <: iLayoutDOM end
abstract type iHTMLAnnotation <: iAnnotation end
abstract type iHTMLLabel <: iHTMLAnnotation end
abstract type iHTMLLabelSet <: iAnnotation end
abstract type iHTMLTemplateFormatter <: iCellFormatter end
abstract type iHTMLTitle <: iHTMLAnnotation end
abstract type iHelpButton <: iAbstractButton end
abstract type iHelpTool <: iActionTool end
abstract type iHexTile <: iGlyph end
abstract type iHoverTool <: iInspectTool end
abstract type iXYGlyph <: iGlyph end
abstract type iImageBase <: iXYGlyph end
abstract type iImage <: iImageBase end
abstract type iImageRGBA <: iImageBase end
abstract type iImageURL <: iXYGlyph end
abstract type iImageURLTexture <: iTexture end
abstract type iIndexFilter <: iFilter end
abstract type iInspector <: iUIElement end
abstract type iIntEditor <: iCellEditor end
abstract type iSelectionPolicy <: iModel end
abstract type iIntersectRenderers <: iSelectionPolicy end
abstract type iIntersectionFilter <: iFilter end
abstract type iInversionFilter <: iFilter end
abstract type iJitter <: iTransform end
abstract type iTextAnnotation <: iAnnotation end
abstract type iLabel <: iTextAnnotation end
abstract type iLabelSet <: iDataAnnotation end
abstract type iLassoSelectTool <: iGestureTool end
abstract type iLegend <: iAnnotation end
abstract type iLegendItem <: iModel end
abstract type iLine <: iGlyph end
abstract type iLineEditTool <: iGestureTool end
abstract type iLinearColorMapper <: iContinuousColorMapper end
abstract type iInterpolator <: iTransform end
abstract type iLinearInterpolator <: iInterpolator end
abstract type iLinearScale <: iContinuousScale end
abstract type iLogAxis <: iContinuousAxis end
abstract type iLogColorMapper <: iContinuousColorMapper end
abstract type iLogScale <: iContinuousScale end
abstract type iLogTickFormatter <: iTickFormatter end
abstract type iLogTicker <: iAdaptiveTicker end
abstract type iMathML <: iMathText end
abstract type iMaxAggregator <: iRowAggregator end
abstract type iScalarExpression <: iModel end
abstract type iMaximum <: iScalarExpression end
abstract type iMenu <: iUIElement end
abstract type iMercatorAxis <: iLinearAxis end
abstract type iMercatorTickFormatter <: iBasicTickFormatter end
abstract type iMercatorTicker <: iBasicTicker end
abstract type iMinAggregator <: iRowAggregator end
abstract type iMinimum <: iScalarExpression end
abstract type iMonthsTicker <: iSingleIntervalTicker end
abstract type iMultiChoice <: iInputWidget end
abstract type iMultiLine <: iLineGlyph end
abstract type iMultiPolygons <: iGlyph end
abstract type iMultiSelect <: iInputWidget end
abstract type iNoOverlap <: iLabelingPolicy end
abstract type iNodeCoordinates <: iGraphCoordinates end
abstract type iNodesAndAdjacentNodes <: iGraphHitTestPolicy end
abstract type iNodesAndLinkedEdges <: iGraphHitTestPolicy end
abstract type iNodesOnly <: iGraphHitTestPolicy end
abstract type iMarking <: iModel end
abstract type iArrowHead <: iMarking end
abstract type iNormalHead <: iArrowHead end
abstract type iNumberEditor <: iCellEditor end
abstract type iNumberFormatter <: iStringFormatter end
abstract type iNumeralTickFormatter <: iTickFormatter end
abstract type iNumericInput <: iInputWidget end
abstract type iOpenHead <: iArrowHead end
abstract type iOpenURL <: iCallback end
abstract type iPanTool <: iDrag end
abstract type iPane <: iUIElement end
abstract type iParagraph <: iMarkup end
abstract type iPasswordInput <: iTextInput end
abstract type iPatch <: iGlyph end
abstract type iPatches <: iGlyph end
abstract type iPercentEditor <: iCellEditor end
abstract type iPlainText <: iBaseText end
abstract type iPointDrawTool <: iGestureTool end
abstract type iPolarTransform <: iCoordinateTransform end
abstract type iPolyAnnotation <: iAnnotation end
abstract type iPolyDrawTool <: iGestureTool end
abstract type iPolyEditTool <: iGestureTool end
abstract type iPolySelectTool <: iGestureTool end
abstract type iPreText <: iParagraph end
abstract type iPrintfTickFormatter <: iTickFormatter end
abstract type iQUADKEYTileSource <: iMercatorTileSource end
abstract type iQuad <: iGlyph end
abstract type iQuadratic <: iLineGlyph end
abstract type iRadioButtonGroup <: iToggleButtonGroup end
abstract type iRadioGroup <: iToggleInputGroup end
abstract type iRange1d <: iRange end
abstract type iRangeSlider <: iAbstractSlider end
abstract type iRangeTool <: iDrag end
abstract type iRay <: iGlyph end
abstract type iRect <: iGlyph end
abstract type iPlotActionTool <: iActionTool end
abstract type iRedoTool <: iPlotActionTool end
abstract type iRendererGroup <: iModel end
abstract type iResetTool <: iPlotActionTool end
abstract type iRow <: iFlexBox end
abstract type iSVGIcon <: iIcon end
abstract type iSaveTool <: iActionTool end
abstract type iScatter <: iMarker end
abstract type iScientificFormatter <: iStringFormatter end
abstract type iScrollBox <: iLayoutDOM end
abstract type iSection <: iMenuItem end
abstract type iSegment <: iLineGlyph end
abstract type iSelect <: iInputWidget end
abstract type iSelectEditor <: iCellEditor end
abstract type iSelection <: iModel end
abstract type iServerSentDataSource <: iWebDataSource end
abstract type iSetValue <: iCallback end
abstract type iSettingsTool <: iActionTool end
abstract type iSlider <: iAbstractSlider end
abstract type iSlope <: iAnnotation end
abstract type iSpacer <: iLayoutDOM end
abstract type iSpan <: iAnnotation end
abstract type iSpinner <: iNumericInput end
abstract type iStack <: iExpression end
abstract type iLayoutProvider <: iModel end
abstract type iStaticLayoutProvider <: iLayoutProvider end
abstract type iStep <: iGlyph end
abstract type iStepInterpolator <: iInterpolator end
abstract type iStringEditor <: iCellEditor end
abstract type iStyles <: iModel end
abstract type iSumAggregator <: iRowAggregator end
abstract type iSwitch <: iToggleInput end
abstract type iSymmetricDifferenceFilter <: iFilter end
abstract type iTMSTileSource <: iMercatorTileSource end
abstract type iTabPanel <: iModel end
abstract type iTableColumn <: iModel end
abstract type iTablerIcon <: iIcon end
abstract type iTabs <: iLayoutDOM end
abstract type iTapTool <: iGestureTool end
abstract type iTeX <: iMathText end
abstract type iTeeHead <: iArrowHead end
abstract type iText <: iGlyph end
abstract type iTextAreaInput <: iTextLikeInput end
abstract type iTextEditor <: iCellEditor end
abstract type iTileRenderer <: iRenderer end
abstract type iTimeEditor <: iCellEditor end
abstract type iTitle <: iTextAnnotation end
abstract type iToggle <: iAbstractButton end
abstract type iToolProxy <: iModel end
abstract type iToolbar <: iUIElement end
abstract type iToolbarPanel <: iHTMLAnnotation end
abstract type iTooltip <: iUIElement end
abstract type iUndoTool <: iPlotActionTool end
abstract type iUnionFilter <: iFilter end
abstract type iUnionRenderers <: iSelectionPolicy end
abstract type iVArea <: iGlyph end
abstract type iVBar <: iGlyph end
abstract type iVBox <: iLayoutDOM end
abstract type iVeeHead <: iArrowHead end
abstract type iWMTSTileSource <: iMercatorTileSource end
abstract type iWedge <: iGlyph end
abstract type iScroll <: iGestureTool end
abstract type iWheelPanTool <: iScroll end
abstract type iWheelZoomTool <: iScroll end
abstract type iWhisker <: iDataAnnotation end
abstract type iXYComponent <: iExpression end
abstract type iXComponent <: iXYComponent end
abstract type iYComponent <: iXYComponent end
abstract type iYearsTicker <: iSingleIntervalTicker end
abstract type iZoomInTool <: iPlotActionTool end
abstract type iZoomOutTool <: iPlotActionTool end
abstract type iDOMAction <: iModel end
abstract type iDOMNode <: iModel end
abstract type iPlaceholder <: iDOMNode end
abstract type iValueRef <: iPlaceholder end
abstract type iDOMColorRef <: iValueRef end
abstract type iDOMElement <: iDOMNode end
abstract type iDOMDiv <: iDOMElement end
abstract type iDOMHTML <: iModel end
abstract type iDOMIndex <: iPlaceholder end
abstract type iDOMPlaceholder <: iDOMNode end
abstract type iDOMSpan <: iDOMElement end
abstract type iDOMTable <: iDOMElement end
abstract type iDOMTableRow <: iDOMElement end
abstract type iDOMTemplate <: iDOMElement end
abstract type iDOMText <: iDOMNode end
abstract type iAction <: iModel end
abstract type iDOMToggleGroup <: iAction end
abstract type iDOMValueOf <: iPlaceholder end
abstract type iDOMValueRef <: iPlaceholder end
const iConnectedXYGlyph = Union{iLine, iPatch}
const iEditTool = Union{iBoxEditTool, iFreehandDrawTool, iLineEditTool, iPointDrawTool, iPolyDrawTool, iPolyEditTool}
const iFillGlyph = Union{iAnnularWedge, iAnnulus, iBlock, iCircle, iEllipse, iHArea, iHBar, iHexTile, iMultiPolygons, iPatch, iPatches, iQuad, iRect, iScatter, iVArea, iVBar, iWedge}
const iHatchGlyph = Union{iAnnularWedge, iAnnulus, iBlock, iCircle, iEllipse, iHArea, iHBar, iHexTile, iMultiPolygons, iPatch, iPatches, iQuad, iRect, iScatter, iVArea, iVBar, iWedge}
const iPolyTool = Union{iPolyDrawTool, iPolyEditTool}
const iSelectTool = Union{iBoxSelectTool, iLassoSelectTool, iPolySelectTool, iTapTool}
const iTap = Union{iBoxEditTool, iFreehandDrawTool, iLineEditTool, iPointDrawTool, iPolyDrawTool, iPolyEditTool, iPolySelectTool, iTapTool}