#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct Jitter <: iJitter

    distribution :: Model.EnumType{(:uniform, :normal)} = :uniform

    mean :: Float64 = 0.0

    range :: Model.Nullable{iRange} = nothing

    width :: Float64 = 1.0
end
