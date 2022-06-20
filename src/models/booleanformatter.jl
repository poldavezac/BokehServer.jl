#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct BooleanFormatter <: iBooleanFormatter

    icon :: Model.EnumType{(Symbol("check-square-o"), Symbol("check-circle"), :check, Symbol("check-circle-o"), Symbol("check-square"))} = :check
end
