#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BinnedTicker <: iBinnedTicker

    mapper :: iScanningColorMapper

    num_major_ticks :: Union{Int64, Model.EnumType{(:auto,)}} = 8
end
