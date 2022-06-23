#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct GroupingInfo <: iGroupingInfo

    aggregators :: Vector{iRowAggregator} = iRowAggregator[]

    collapsed :: Bool = false

    getter :: String = ""
end
