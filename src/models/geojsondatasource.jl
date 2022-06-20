#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GeoJSONDataSource <: iGeoJSONDataSource

    geojson :: Model.JSONString

    selected :: Model.ReadOnly{iSelection} = Selection()

    selection_policy :: iSelectionPolicy = UnionRenderers()
end
